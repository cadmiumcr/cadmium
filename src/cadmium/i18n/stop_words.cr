module Cadmium
  module I18n
    @@lang : Symbol | Array(Symbol) = :en

    module StopWords
      # a list of commonly used words that have little meaning and can be excluded
      # from analysis.
      @@stop_words : Array(String) = [""]
      @@lang : Symbol | Array(Symbol) = :en

      macro stop_words(language)
        def self.stop_words_{{language}}
        {{ read_file("#{__DIR__}/data/stopwords/#{language}.txt") }}.split("\n")
        end
      end
    end
  end
end
