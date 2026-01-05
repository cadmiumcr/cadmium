require "./lemmatizer/*"

module Cadmium
  module StringExtension
    def lemmatize(lemmatizer = Cadmium::Lemmatizer::WordNetLemmatizer)
      lemmatizer.lemmatize(self)
    end

    def tokenize_and_lemmatize(lemmatizer = Cadmium::Lemmatizer::WordNetLemmatizer, keep_stops = false)
      lemmatizer.tokenize_and_lemmatize(self, keep_stops)
    end
  end
end
