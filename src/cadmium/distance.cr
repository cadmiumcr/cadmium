require "./distance/*"

module Cadmium
  module Distance
    def self.levenshtein(s1 : String, s2 : String)
      Levenshtein.distance(s1, s2)
    end

    def self.jaro_winkler(s1 : String, s2 : String)
      JaroWinkler.new.distance(s1, s2)
    end
  end
end
