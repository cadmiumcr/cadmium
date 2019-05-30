require "../tokenizer"
require "../stemmer"
require "../inflectors"
require "../transliterator"
require "../phonetics"
require "../sentiment"

class String
  include Cadmium::StringExtension
end
