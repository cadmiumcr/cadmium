module Cadmium
  module Tokenizer
    abstract class TokenizerBase
      abstract def tokenize(string : String) : Array(String)

      def trim(arr)
        if arr[0] == ""
          arr.shift
        end

        if arr[-1] == ""
          arr.pop
        end

        arr
      end
    end
  end
end
