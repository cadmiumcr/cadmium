require "../tokenizer"

class String
  include Cadmium::Tokenizer::StringExtension
  include Cadmium::Stemmers::StringExtension
  include Cadmium::Inflectors::StringExtension
  include Cadmium::Transliterator::StringExtension
end
