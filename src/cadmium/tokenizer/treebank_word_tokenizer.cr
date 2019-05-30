require "./tokenizer"

module Cadmium
  # The Treebank tokenizer uses regular expressions to tokenize text as in Penn Treebank.
  # This implementation is a port of the tokenizer sed script written by Robert McIntyre
  # and available at http://www.cis.upenn.edu/~treebank/tokenizer.sed.
  class TreebankWordTokenizer < Tokenizer
    CONTRACTIONS_2 = [
      /(.)('ll|'re|'ve|n't|'s|'m|'d)\b/i,
      /\b(can)(not)\b/i,
      /\b(D)('ye)\b/i,
      /\b(Gim)(me)\b/i,
      /\b(Gon)(na)\b/i,
      /\b(Got)(ta)\b/i,
      /\b(Lem)(me)\b/i,
      /\b(Mor)('n)\b/i,
      /\b(T)(is)\b/i,
      /\b(T)(was)\b/i,
      /\b(Wan)(na)\b/i,
    ]

    CONTRACTIONS_3 = [
      /\b(Whad)(dd)(ya)\b/i,
      /\b(Wha)(t)(cha)\b/i,
    ]

    def tokenize(string : String) : Array(String)
      CONTRACTIONS_2.each do |rex|
        string = string.gsub(rex, "\\1 \\2")
      end

      CONTRACTIONS_3.each do |rex|
        string = string.gsub(rex, "\\1 \\2 \\3")
      end

      # Most punctuation
      string = string.gsub(/([^\w\.\'\-\/\+\<\>,&])/, " \\1 ")

      # Commas if followed by a space
      string = string.gsub(/(,\s)/, " \\1")

      # Single quotes if followed by a space
      string = string.gsub(/('\s)/, " \\1")

      # Preiods before newline or end of string
      string = string.gsub(/\. *(\n|$)/, " . ")

      string.split(/\s+/).reject(&.empty?)
    end
  end
end
