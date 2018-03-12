require "../util/stop_words"
require "../tokenizer/aggressive_tokenizer"

module Cadmium
  module Stemmers
    abstract class Stemmer
      include Cadmium::Util::StopWords

      def self.stem(token)
        token
      end

      def self.add_stop_word(word)
        @@stop_words.push word
      end

      def self.add_stop_words(words)
        @@stop_words.concat words
      end

      def self.remove_stop_word(word)
        remove_stop_words([word])
      end

      def self.remove_stop_words(words)
        words.each do |word|
          @@stop_words.delete(word)
        end
        @@stop_words
      end

      def self.tokenize_and_stem(text, keep_stops = false)
        stemmed_tokens = [] of String
        lowercase_text = text.downcase
        tokens = Cadmium::Tokenizer::AggressiveTokenizer.new.tokenize(lowercase_text)

        if keep_stops
          tokens.each { |token| stemmed_tokens.push(stem(token)) }
        else
          tokens.each { |token| stemmed_tokens.push(stem(token)) unless @@stop_words.includes?(token) }
        end

        stemmed_tokens
      end
    end
  end
end
