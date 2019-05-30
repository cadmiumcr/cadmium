require "./regex_tokenizer"

module Cadmium
  class WhitespaceTokenizer < RegexTokenizer
    REGEX_PATTERN = /\s+/

    def initialize
      super(REGEX_PATTERN)
    end
  end
end
