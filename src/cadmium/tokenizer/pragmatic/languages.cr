require "./languages/common"

module Cadmium
  module Tokenizer
    class PragmaticTokenizer
      class Languages
        LANGUAGE_CODES = {
          en: English,
          ar: Arabic,
          bg: Bulgarian,
          ca: Catalan,
          cs: Czech,
          da: Danish,
          de: Deutsch,
          el: Greek,
          es: Spanish,
          fa: Persian,
          fi: Finnish,
          fr: French,
          id: Indonesian,
          it: Italian,
          lv: Latvian,
          nl: Dutch,
          nn: Norwegian,
          nb: Norwegian,
          no: Norwegian,
          pl: Polish,
          pt: Portuguese,
          ro: Romanian,
          ru: Russian,
          sk: Slovak,
          sv: Swedish,
          tr: Turkish,
        }

        def self.get_language_by_code(code)
          code ||= :en
          LANGUAGE_CODES[code] || Common
        end
      end
    end
  end
end
