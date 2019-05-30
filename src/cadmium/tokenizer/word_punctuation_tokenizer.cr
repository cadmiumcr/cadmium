require "./regex_tokenizer"

module Cadmium
  class WordPunctuationTokenizer < RegexTokenizer
    REGEX_PATTERN = /(\w+|[а-я0-9_]+|\.|\!|\'|\"")/i

    def initialize
      super(REGEX_PATTERN)
    end
  end
end
