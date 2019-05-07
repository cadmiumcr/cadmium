require "../tokenizer"

class String
  include Cadmium::Tokenizer::StringExtension
  include Cadmium::Stemmer::StringExtension
  include Cadmium::Inflector::StringExtension
  include Cadmium::Transliterator::StringExtension
  include Cadmium::Phonetics::StringExtension
  include Cadmium::Sentiment::StringExtension
end
