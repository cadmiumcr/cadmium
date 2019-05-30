module Cadmium
  module LevenshteinDistance
    # Returns the Damerau-Levenshtein distance between strings. Counts the distance
    # between two strings by returning the number of edit operations required to
    # convert `s1` into `s2`.
    def self.distance(s1 : String, s2 : String)
      return s2.size if s1.empty?
      return s1.size if s2.empty?

      a = s1.downcase
      b = s2.downcase

      return 0 if s1 == s2

      costs = Array(Int32).new(b.size + 1, 0) # i == 0
      (1..a.size).each do |i|
        costs[0], nw = i, i - 1 # j == 0; nw is lev(i - 1, j)
        (1..b.size).each do |j|
          costs[j], nw = [costs[j] + 1, costs[j - 1] + 1, a[i - 1] == b[j - 1] ? nw : nw + 1].min, costs[j]
        end
      end
      costs[b.size]
    end
  end
end
