require "./cadmium/core_ext/**"
require "./cadmium/util/*"
require "./cadmium/*"

# Cadmium is a Natrual Language Processing (NLP) library for Crystal. It includes several
# modules and classes for processing sentences and splitting them into digestable pieces.
module Cadmium
  def self.stem(string, stemmer = Cadmium::Stemmer::PorterStemmer)
    stemmer.stem(string)
  end

  def self.tokenize(phrase, tokenizer_class = Cadmium::Tokenizer::Pragmatic, **options)
    tokenizer = tokenizer_class.new(**options)
    tokenizer.tokenize(phrase)
  end

  def self.tokenize_and_stem(string, keep_stops = false, stemmer = Cadmium::Stemmer::PorterStemmer)
    stemmer.tokenize_and_stem(string, keep_stops)
  end

  def self.levenshtein_distance(s1 : String, s2 : String)
    Distance.levenshtein(s1, s2)
  end

  def self.jaro_winkler_distance(s1 : String, s2 : String)
    Distance.jaro_winkler(s1, s2)
  end

  def self.transliterate(source, **options)
    Transliterator.transliterate(source, **options)
  end
end
