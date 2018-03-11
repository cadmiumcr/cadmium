require "./tokenizer_base"

module Cadmium
  module Tokenizer
    class SentenceTokenizer < TokenizerBase
      REGEX_PATTERN = /([\"\'\‘\“\'\"\[\(\{\⟨][^\.\?\!]+[\.\?\!][\"\'\’\”\'\"\]\)\}\⟩]|[^\.\?\!]+[\.\?\!])\s?/

      def tokenize(string : String) : Array(String)
        tokens = string.split(REGEX_PATTERN).reject(&.empty?).map(&.strip)
        trim(tokens)
      end
    end
  end
end
