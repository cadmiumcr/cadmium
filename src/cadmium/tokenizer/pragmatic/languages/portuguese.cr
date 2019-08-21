require "./common"

module Cadmium
  class PragmaticTokenizer < Tokenizer
    module Languages
      class Portuguese < Languages::Common
        include Cadmium::I18n::StopWords
        stop_words pt
        ABBREVIATIONS = Set(String).new
        STOP_WORDS    = stop_words_pt
        CONTRACTIONS  = {} of String => String
      end
    end
  end
end
