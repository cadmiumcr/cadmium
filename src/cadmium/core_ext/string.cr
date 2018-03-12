require "../tokenizer"

class String
  include Cadmium::Tokenizer::StringExtension
  include Cadmium::Stemmers::StringExtension
end
