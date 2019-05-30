require "./phonetics/*"

module Cadmium
  module StringExtension
    def phonetics(max_length = nil, phonetics = Cadmium::Metaphone)
      phonetics.process(self, max_length)
    end

    def sounds_like(word, phonetics = Cadmium::Metaphone)
      phonetics.compare(self, word)
    end

    def tokenize_and_phoneticize(keep_stops = false, phonetics = Cadmium::Metaphone)
      phonetics.tokenize_and_phoneticize(self, keep_stops)
    end
  end
end
