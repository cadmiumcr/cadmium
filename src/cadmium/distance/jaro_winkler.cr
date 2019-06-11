require "bit_array"
require "set"

module Cadmium
  # Computes the Jaro distance between two string.
  # Code credit goes to kostya. https://github.com/kostya/jaro_winkler
  class JaroWinklerDistance
    DEFAULT_ADJ_TABLE = [
      ['A', 'E'], ['A', 'I'], ['A', 'O'], ['A', 'U'], ['B', 'V'], ['E', 'I'], ['E', 'O'], ['E', 'U'], ['I', 'O'],
      ['I', 'U'], ['O', 'U'], ['I', 'Y'], ['E', 'Y'], ['C', 'G'], ['E', 'F'], ['W', 'U'], ['W', 'V'], ['X', 'K'],
      ['S', 'Z'], ['X', 'S'], ['Q', 'C'], ['U', 'V'], ['M', 'N'], ['L', 'I'], ['Q', 'O'], ['P', 'R'], ['I', 'J'],
      ['2', 'Z'], ['5', 'S'], ['8', 'B'], ['1', 'I'], ['1', 'L'], ['0', 'O'], ['0', 'Q'], ['C', 'K'], ['G', 'J'],
      ['E', ' '], ['Y', ' '], ['S', ' '],
    ].reduce(Set(Tuple(Char, Char)).new) do |set, elem|
      c1, c2 = elem
      set << {c1, c2}
      set << {c2, c1}
      set << {c1.downcase, c2.downcase}
      set << {c2.downcase, c1.downcase}
      set << {c1.downcase, c2}
      set << {c2, c1.downcase}
      set << {c1, c2.downcase}
      set << {c2.downcase, c1}
      set
    end

    def initialize(@weight = 0.1, @threshold = 0.7, @ignore_case = false, @adj_table = false)
      raise ArgumentError.new("weight should be <= 0.25") if @weight > 0.25
    end

    def distance(s1 : String, s2 : String)
      distance(s1.chars, s2.chars)
    end

    def distance(codes1 : Array(Char), codes2 : Array(Char))
      jaro_distance = jaro_distance(codes1, codes2)

      if jaro_distance < @threshold
        jaro_distance
      else
        codes1, codes2 = codes2, codes1 if codes1.size > codes2.size
        len1 = codes1.size
        max_4 = len1 > 4 ? 4 : len1
        prefix = 0
        while prefix < max_4 && codes1[prefix] == codes2[prefix]
          prefix += 1
        end
        jaro_distance + prefix * @weight * (1 - jaro_distance)
      end
    end

    def jaro_distance(s1 : String, s2 : String)
      jaro_distance(s1.chars, s2.chars)
    end

    def jaro_distance(codes1 : Array(Char), codes2 : Array(Char))
      codes1, codes2 = codes2, codes1 if codes1.size > codes2.size
      len1, len2 = codes1.size, codes2.size
      return 0.0 if len1 == 0 || len2 == 0

      if @ignore_case
        codes1.map! { |c| c = c.ord; c >= 97 && c <= 122 ? (c - 32).chr : c.chr }
        codes2.map! { |c| c = c.ord; c >= 97 && c <= 122 ? (c - 32).chr : c.chr }
      end

      window = (len2 / 2 - 1).clamp(0, Float64::MAX)
      flags1, flags2 = BitArray.new(len1), BitArray.new(len2)

      match_count = match_count(len1, len2, flags1, flags2, codes1, codes2, window)

      return 0.0 if match_count == 0

      transposition_count = transposition_count(len1, len2, flags1, flags2, codes1, codes2)

      similar_count = similar_count(len1, len2, flags1, flags2, codes1, codes2, match_count)

      t = transposition_count / 2
      jaro_distance(len1, len2, match_count, t, similar_count)
    end

    private def jaro_distance(len1, len2, match_count, transposition_count, similar_count)
      match_count = similar_count / 10.0 + match_count if @adj_table
      (match_count / len1 + match_count / len2 + (match_count - transposition_count) / match_count) / 3
    end

    def match_count(len1, len2, flags1, flags2, codes1, codes2, window)
      # count number of matching characters
      match_count = 0.0

      (0...len1).each do |i|
        left = (i >= window) ? (i - window).to_i : 0
        right = (i + window <= len2 - 1) ? (i + window).to_i : (len2 - 1).to_i
        right = len2 - 1 if right > len2 - 1
        (left..right).each do |j|
          next if flags2[j]

          if codes1[i] == codes2[j]
            flags1[i] = true
            flags2[j] = true
            match_count += 1
            break
          end
        end
      end

      match_count
    end

    # count number of transpositions
    private def transposition_count(len1, len2, flags1, flags2, codes1, codes2)
      transposition_count = k = 0

      (0...len1).each do |i|
        next unless flags1[i]

        jj = 0
        (k...len2).each do |j|
          if flags2[j]
            k = j + 1
            jj = j
            break
          end
        end

        transposition_count += 1 if codes1[i] != codes2[jj]
      end

      transposition_count
    end

    # count similarities in nonmatched characters
    private def similar_count(len1, len2, flags1, flags2, codes1, codes2, match_count)
      similar_count = 0

      if @adj_table && len1 > match_count
        (0...len1).each do |i|
          next if flags1[i]
          (0...len2).each do |j|
            next if flags2[j]

            if DEFAULT_ADJ_TABLE.includes?({codes1[i], codes2[j]})
              similar_count += 3
              break
            end
          end
        end
      end

      similar_count
    end
  end
end
