module Cadmium
  module Tokenizer
    class PragmaticTokenizer
      class Languages
        module Common
          PUNCTUATION_MAP = {"。" => "♳", "．" => "♴", "." => "♵", "！" => "♶", "!" => "♷", "?" => "♸", "？" => "♹", "、" => "♺", "¡" => "⚀", "¿" => "⚁", "„" => "⚂", "“" => "⚃", "[" => "⚄", "]" => "⚅", "\"" => "☇", "#" => "☈", "$" => "☉", "%" => "☊", "&" => "☋", "(" => "☌", ")" => "☍", "*" => "☠", "+" => "☢", "," => "☣", ":" => "☤", ";" => "☥", "<" => "☦", "=" => "☧", ">" => "☀", "@" => "☁", "^" => "☂", "_" => "☃", "`" => "☄", "'" => "☮", "{" => "♔", "|" => "♕", "}" => "♖", "~" => "♗", "-" => "♘", "«" => "♙", "»" => "♚", "”" => "⚘", "‘" => "⚭"}
          ABBREVIATIONS   = Set.new([] of String)
          STOP_WORDS      = Set.new([] of String)
          CONTRACTIONS    = {} of String => String

          class SingleQuotes
            ALNUM_QUOTE     = /(\w|\D)'(?!')(?=\W|$)/
            QUOTE_WORD      = /(\W|^)'(?=\w)/
            QUOTE_NOT_TWAS1 = /(\W|^)'(?!twas)/i
            QUOTE_NOT_TWAS2 = /(\W|^)‘(?!twas)/i

            # This 'special treatment' is actually relevant for many other tests. Alter core regular expressions!
            def handle_single_quotes(text)
              # special treatment for "'twas"
              text.gsub!(QUOTE_NOT_TWAS1, "\1 " << PUNCTUATION_MAP["'"] << " ")
              text.gsub!(QUOTE_NOT_TWAS2, "\1" << PUNCTUATION_MAP["‘"] << " ")

              text.gsub!(QUOTE_WORD, " " << PUNCTUATION_MAP["'"])
              text.gsub!(ALNUM_QUOTE, "\1" << PUNCTUATION_MAP["'"] << " ")
              text
            end
          end
        end
      end
    end
  end
end
