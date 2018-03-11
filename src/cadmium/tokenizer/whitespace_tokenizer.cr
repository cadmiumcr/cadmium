require "./regex_tokenizer"

module Cadmium
  module Tokenizer
    class WhitespaceTokenizer < RegexTokenizer
      REGEX_PATTERN = /[^A-Za-zА-Яа-я0-9_]+/

      def initialize
        super(REGEX_PATTERN)
      end
    end
  end
end
