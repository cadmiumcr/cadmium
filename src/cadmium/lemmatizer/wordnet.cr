require "../wordnet"
require "../i18n/stop_words"
require "../tokenizer/aggressive_tokenizer"

module Cadmium
  module Lemmatizer
    module WordNetLemmatizer
      include Cadmium::I18n::StopWords

      def self.lemmatize(token, pos : Symbol | String? = nil)
        lemmas = if pos
                   WordNet.morphy(token, pos)
                 else
                   WordNet.morphy(token)
                 end
        return token if lemmas.empty?
        lemmas.min_by(&.size)
      end

      def self.tokenize_and_lemmatize(text, keep_stops = false)
        lemmatized_tokens = [] of String
        lowercase_text = text.downcase
        tokens = Cadmium::AggressiveTokenizer.new.tokenize(lowercase_text)

        if keep_stops
          tokens.each { |token| lemmatized_tokens.push(lemmatize(token)) }
        else
          tokens.each { |token| lemmatized_tokens.push(lemmatize(token)) unless @@stop_words.includes?(token) }
        end

        lemmatized_tokens
      end
    end
  end
end
