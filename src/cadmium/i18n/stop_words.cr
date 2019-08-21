module Cadmium
  module I18n
    @@lang : Symbol | Array(Symbol) = :en

    module StopWords
      DATA_DIR = "#{__DIR__}/data/stopwords/"
      # a list of commonly used words that have little meaning and can be excluded
      # from analysis.
      @@stop_words : Array(String) = {{ read_file("#{DATA_DIR.id}en.txt").split("\n") }}

      macro stop_words(*languages)
        {% if languages.includes?("all_languages") %}
          files = Dir.open(DATA_DIR)
          files.each_child do |file|
            languages << file.chomp(".txt")
          end
        {% end %}
          {% for language, index in languages %}
        def self.stop_words_{{language}} : Array(String)
        {{ read_file("#{DATA_DIR.id}#{language}.txt").split("\n") }}
        end
        {% end %}
      end
    end
  end
end
