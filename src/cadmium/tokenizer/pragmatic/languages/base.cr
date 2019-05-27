module Cadmium
  module Tokenizer
    class Pragmatic
      module Languages
        abstract class Base
          # abstract def self.punctuation_map : Hash(String, String)

          # abstract def self.contractions : Hash(String, String)

          # abstract def self.abbreviations : Set(String)

          # abstract def self.stop_words : Set(String)

          # abstract def self.handle_single_quotes(text) : String
        end
      end
    end
  end
end
