require "./stemmer/*"

module Cadmium
  module StringExtension
    def stem(stemmer = Cadmium::PorterStemmer)
      stemmer.stem(self)
    end

    def tokenize_and_stem(stemmer = Cadmium::PorterStemmer, keep_stops = false)
      stemmer.tokenize_and_stem(self, keep_stops)
    end
  end
end
