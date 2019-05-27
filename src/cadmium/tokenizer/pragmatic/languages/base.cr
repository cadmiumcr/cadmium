module Cadmium
  module Tokenizer
    class Pragmatic
      module Languages
        abstract class Base
          def self.contractions
            {} of String => String
          end

          def self.abbreviations
            Set(String).new
          end

          def self.stop_words
            Set(String).new
          end

          def self.handle_single_quotes(text)
            text
          end
        end
      end
    end
  end
end
