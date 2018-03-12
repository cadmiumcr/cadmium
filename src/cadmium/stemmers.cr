require "./stemmers/*"

module Cadmium
  module Stemmers
    module StringExtension
      def stem(stemmer = Cadmium::Stemmers::PorterStemmer)
        stemmer.stem(self)
      end

      def tokenize_and_stem(stemmer = Cadmium::Stemmers::PorterStemmer, keep_stops = false)
        stemmer.tokenize_and_stem(self, keep_stops)
      end
    end
  end
end
