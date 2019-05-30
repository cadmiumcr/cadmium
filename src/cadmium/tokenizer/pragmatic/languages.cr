require "./languages/common"

require "./languages/english"
require "./languages/deutsch"

module Cadmium
  class PragmaticTokenizer
    module Languages
      @@language_codes = {
        en: English,
        # ar: Arabic,
        # bg: Bulgarian,
        # ca: Catalan,
        # cs: Czech,
        # da: Danish,
        de: Deutsch,
        # el: Greek,
        # es: Spanish,
        # fa: Persian,
        # fi: Finnish,
        # fr: French,
        # id: Indonesian,
        # it: Italian,
        # lv: Latvian,
        # nl: Dutch,
        # nn: Norwegian,
        # nb: Norwegian,
        # no: Norwegian,
        # pl: Polish,
        # pt: Portuguese,
        # ro: Romanian,
        # ru: Russian,
        # sk: Slovak,
        # sv: Swedish,
        # tr: Turkish,
      }

      def self.get_language_by_code(code)
        code ||= :en
        @@language_codes[code] || Common
      end
    end
  end
end
