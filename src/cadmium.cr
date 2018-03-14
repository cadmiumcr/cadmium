require "./cadmium/*"
require "./cadmium/core_ext/**"

# Cadmium is a Natrual Language Processing (NLP) library for Crystal. It includes several
# modules and classes for processing sentences and splitting them into digestable pieces.
module Cadmium
  def self.stem(string, stemmer = Cadmium::Stemmers::PorterStemmer)
    stemmer.stem(string)
  end

  def self.tokenize_and_stem(string, keep_stops = false, stemmer = Cadmium::Stemmers::PorterStemmer)
    stemmer.tokenize_and_stem(string, keep_stops)
  end

  def self.levenshtein_distance(s1 : String, s2 : String)
    Distance.levenshtein(s1, s2)
  end

  def self.jaro_winkler_distance(s1 : String, s2 : String)
    Distance.jaro_winkler(s1, s2)
  end
end
