require "./distance/*"

module Cadmium
  def self.levenshtein_distance(s1 : String, s2 : String)
    LevenshteinDistance.distance(s1, s2)
  end

  def self.jaro_winkler_distance(s1 : String, s2 : String)
    @@jaro_winkler ||= JaroWinklerDistance.new
    @@jaro_winkler.distance(s1, s2)
  end
end
