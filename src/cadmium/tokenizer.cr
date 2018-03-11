require "./tokenizer/*"

module Cadmium
  module Tokenizer
    module StringExtension
      def tokenize(tokenizer = Cadmium::Tokenizer::WordPunctuationTokenizer, *args, **kwargs)
        tokenizer = tokenizer.new(*args, **kwargs)
        tokenizer.tokenize(self)
      end
    end
  end
end
