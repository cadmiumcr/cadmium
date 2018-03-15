require "./tokenizer/aggressive_tokenizer"
require "./util/stop_words"
require "./phonetics/*"

module Cadmium
  abstract class Phonetics
    include Cadmium::Util::StopWords

    @@tokenizer = Cadmium::Tokenizer::AggressiveTokenizer.new

    def self.compare(word1, word2)
      process(word1) == process(word2)
    end

    def self.tokenize_and_phoneticize(word, keep_stops = false)
      phoneticized_tokens = [] of String
      @@tokenizer.tokenize(word).each do |token|
        if keep_stops || @@stop_words.includes?(token) == false
          phoneticized_tokens.push process(token)
        end
      end
      phoneticized_tokens
    end

    module StringExtension
      def phonetics(max_length = nil, phonetics = Cadmium::Phonetics::Metaphone)
        phonetics.process(self, max_length)
      end

      def sounds_like(word, phonetics = Cadmium::Phonetics::Metaphone)
        phonetics.compare(self, word)
      end

      def tokenize_and_phoneticize(keep_stops = false, phonetics = Cadmium::Phonetics::Metaphone)
        phonetics.tokenize_and_phoneticize(self, keep_stops)
      end
    end
  end
end
