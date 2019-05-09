module Cadmium
  module WordNet
    class Lemma
      SPACE         = " "
      POS_SHORTHAND = {:v => :verb, :n => :noun, :a => :adj, :r => :adv}

      # The word this lemma represents
      getter word : String

      # The part of speech (noun, verb, adjective) of this lemma.
      # One of "n", "v", "a" (adjective), or "r" (adverb)
      getter pos : String

      # The number of times the sense is tagged in various semantic concordance texts.
      # A tagsense_count of 0 indicates that the sense has not been semantically tagged.
      getter tagsense_count : Int32

      # The offset, in bytes, at which the synsets contained in this lemma are stored
      # in WordNet's internal database.
      getter synset_offsets : Array(Int32)

      # A unique integer id that references this lemma. Used internally within WordNet's database.
      getter id : Int32

      # An array of valid pointer symbols for this lemma. The list of all valid
      # pointer symbols is defined in pointers.cr.
      getter pointer_symbols : Array(String)

      @@cache = {} of String => Hash(String, Tuple(String, Int32))

      # Create a lemma from a line in an lexicon file. You should not be creating Lemmas by hand; instead,
      # use the WordNet::Lemma.find and WordNet::Lemma.find_all methods to find the Lemma for a word.
      def initialize(lexicon_line : String, id : Int32)
        @id = id
        line = lexicon_line.split(" ")

        @word = line.shift
        @pos = line.shift
        synset_count = line.shift.to_i
        pend = line.shift.to_i
        @pointer_symbols = line[0, pend]
        line.delete_at(0, pend)
        line.shift # Throw away redundant sense_cnt
        @tagsense_count = line.shift.to_i
        @synset_offsets = line[0, synset_count].map(&.to_i)
        line.delete_at(0, synset_count)
      end

      # Return a list of synsets for this Lemma. Each synset represents a different sense, or meaning, of the word.
      def synsets
        @synset_offsets.reduce([] of Synset) { |acc, i| acc << Synset.new(@pos, i) }
      end

      # Returns a compact string representation of this lemma, e.g. "fall, v" for
      # the verb form of the word "fall".
      def to_s(io)
        io << @word << ", " << @pos
      end

      # Find all lemmas for this word across all known parts of speech
      def self.find_all(word : String)
        [:noun, :verb, :adj, :adv].flat_map do |pos|
          find(word, pos) || [] of Lemma
        end
      end

      # Find a lemma for a given word and pos. Valid parts of speech are:
      # "adj", "adv", "noun", "verb". Additionally, you can use the shorthand
      # forms of each of these ("a", "r", "n", "v")/
      def self.find(word, pos)
        # Map shorthand POS to full forms
        pos = POS_SHORTHAND.has_key?(pos) ? POS_SHORTHAND[pos] : pos
        pos = pos.to_s

        cache = @@cache[pos] ||= build_cache(pos)
        if cache.has_key?(word)
          found = cache[word]
          Lemma.new(*found)
        end
      end

      private def self.build_cache(pos)
        cache = {} of String => Tuple(String, Int32)
        DB.open(File.join("dict", "index.#{pos}")).each_line.each_with_index do |line, index|
          word = line[0, line.index(SPACE) || -1]
          cache[word] = {line, index + 1}
        end
        cache
      end
    end
  end
end
