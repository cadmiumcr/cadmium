require "./tokenizer/*"

module Cadmium
  module StringExtension
    def tokenize(tokenizer = Cadmium::WordPunctuationTokenizer, *args, **kwargs)
      tokenizer = tokenizer.new(*args, **kwargs)
      tokenizer.tokenize(self)
    end
  end
end
