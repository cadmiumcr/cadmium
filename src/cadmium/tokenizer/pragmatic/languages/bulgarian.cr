require "./common"

module Cadmium
  class PragmaticTokenizer < Tokenizer
    module Languages
      class Bulgarian < Languages::Common
        include Cadmium::I18n::StopWords
        stop_words bg
        ABBREVIATIONS = Set.new(%w[акад ал б.р б.ред бел.а бел.пр бр бул в вж вкл вм вр г ген гр дж дм доц др ем заб зам инж к.с кв кв.м кг км кор куб куб.м л лв м м.г мин млн млрд мм н.с напр пл полк проф р рис с св сек см сп срв ст стр т т.г т.е т.н т.нар табл тел у ул фиг ха хил ч чл щ.д]).freeze
        STOP_WORDS    = stop_words_bg
        CONTRACTIONS  = {} of String => String
      end
    end
  end
end
