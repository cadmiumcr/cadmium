require "./tokenizer_base"

module Cadmium
  module Tokenizer
    class CaseTokenizer < TokenizerBase
      @preserve_apostrophe : Bool

      def initialize(preserve_apostrophe = nil)
        @preserve_apostrophe = preserve_apostrophe.nil? ? false : preserve_apostrophe
      end

      def tokenize(string : String) : Array(String)
        whitelist = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
        result = string.chars.reduce("") do |acc, cur|
          if (cur.downcase != cur.upcase) || whitelist.includes?(cur.downcase) || (cur == '\'' && @preserve_apostrophe)
            acc += cur
          else
            acc += ' '
          end
        end
        trim(result.gsub(/\s+/, ' ').split(' '))
      end
    end
  end
end
