require "./tokenizer_base"

module Cadmium
  module Tokenizer
    class CaseTokenizer < TokenizerBase
      @preserve_apostrophe : Bool

      def initialize(preserve_apostrophe = nil)
        @preserve_apostrophe = preserve_apostrophe.nil? ? false : preserve_apostrophe
      end

      def tokenize(string : String) : Array(String)
        whitelist = ('0'..'9').to_a
        result = string.chars.reduce("") do |acc, cur|
          if (cur.downcase != cur.upcase) || whitelist.includes?(cur.downcase) || (cur == '\'' && @preserve_apostrophe)
            acc += cur
          else
            acc += ' '
          end
          acc
        end
        trim(result.gsub(/\s+/, ' ').split(' '))
      end
    end
  end
end
