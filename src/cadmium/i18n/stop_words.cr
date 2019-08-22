module Cadmium
  module I18n
    @@lang : Symbol | Array(Symbol) = :en

    module StopWords
      DATA_DIR = "#{__DIR__}/data/stopwords/"
      # a list of commonly used words that have little meaning and can be excluded
      # from analysis.
      @@stop_words : Array(String) = {{ read_file("#{DATA_DIR.id}en.txt").split("\n") }}

      macro stop_words(*languages)
          {% for language, index in languages %}
          {% if language.id != "all_languages" %}
        def self.stop_words_{{language}} : Array(String)
        {{ read_file("#{DATA_DIR.id}#{language}.txt").split("\n") }}
      end
         {% else %}
         def self.stop_words_all_languages : Hash(String, Array(String))
         # read_file only accepts literals so it can't be fed dynamically with non-macro variables (ie we can't parse the data directory and give it the filenames)
         Hash(String, Array(String)).from_json({{ read_file("#{DATA_DIR.id}all-languages.json") }})
        end
        {% end %}
        {% end %}
      end
    end
  end
end
