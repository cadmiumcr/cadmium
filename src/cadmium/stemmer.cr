require "./stemmer/*"

module Cadmium
  module Stemmer
    module StringExtension
      def stem(stemmer = Cadmium::Stemmer::PorterStemmer)
        stemmer.stem(self)
      end

      def tokenize_and_stem(stemmer = Cadmium::Stemmer::PorterStemmer, keep_stops = false)
        stemmer.tokenize_and_stem(self, keep_stops)
      end
    end
  end
end
