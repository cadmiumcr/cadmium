require "./common"

module Cadmium
  class PragmaticTokenizer < Tokenizer
    module Languages
      class Czech < Languages::Common
        include Cadmium::I18n::StopWords
        stop_words cs
        ABBREVIATIONS = Set(String).new
        STOP_WORDS    = stop_words_cs
        CONTRACTIONS  = {} of String => String
      end
    end
  end
end
