require "json"

module Cadmium
  module Util
    module StopWords
      include JSON::Serializable
      include JSON::Serializable::Unmapped
      # a list of commonly used words that have little meaning and can be excluded
      # from analysis.
      @@lang : Symbol = :en
      I18N_ALL_STOPWORDS = Hash(String, Array(String)).from_json({{ read_file("#{__DIR__}/../../../data/stopwords.json") }})
      @@stop_words : Array(String) = i18n_stop_words(@@lang)

      def self.i18n_stop_words(lang = nil) : Array(String)
        @@lang = lang.nil? ? :en : lang
        @@stop_words = I18N_ALL_STOPWORDS[@@lang.to_s]
      end
    end
  end
end
