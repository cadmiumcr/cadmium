require "./tokenizer_base"

module Cadmium
  module Tokenizer
    class RegexTokenizer < TokenizerBase
      @pattern : Regex
      @gaps : Bool
      @discard_empty : Bool

      def initialize(pattern : Regex, *, gaps = nil, discard_empty = nil)
        @pattern = pattern
        @gaps = gaps.nil? ? true : gaps
        @discard_empty = discard_empty.nil? ? true : discard_empty
      end

      def tokenize(string : String) : Array(String)
        if @gaps
          results = string.split(@pattern)
          @discard_empty ? results.reject { |r| r == "" || r == " " } : results
        else
          string.split(@pattern)
        end
      end
    end
  end
end
