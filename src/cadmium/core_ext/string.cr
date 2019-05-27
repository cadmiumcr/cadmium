require "../tokenizer"
require "../stemmer"
require "../inflectors"
require "../transliterator"
require "../phonetics"
require "../sentiment"

class String
  include Cadmium::Tokenizer::StringExtension
  include Cadmium::Stemmer::StringExtension
  include Cadmium::Inflector::StringExtension
  include Cadmium::Transliterator::StringExtension
  include Cadmium::Phonetics::StringExtension
  include Cadmium::Sentiment::StringExtension
end
