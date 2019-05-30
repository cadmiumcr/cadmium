require "./cadmium/core_ext/**"
require "./cadmium/util/*"
require "./cadmium/*"

# Cadmium is a Natrual Language Processing (NLP) library for Crystal. It includes several
# modules and classes for processing sentences and splitting them into digestable pieces.
#
# Every module in Cadmium is accessable via a convenience method directly from the
# Cadmium module. This allows you to type `Cadmium.bayes_classifier` instead of
# the more explicit `Cadmium::BayesClassifier`.
module Cadmium
  extend self
  # :nodoc:
  MODULES = {
    bayes_classifier:           Cadmium::BayesClassifier,
    jaro_winkler_distance:      Cadmium::JaroWinklerDistance,
    levenshtein_distance:       Cadmium::LevenshteinDistance,
    edge_weighted_digraph:      Cadmium::EdgeWeightedDigraph,
    count_inflector:            Cadmium::CountInflector,
    noun_inflector:             Cadmium::NounInflector,
    present_tense_inflector:    Cadmium::PresentTenseInflector,
    metaphone:                  Cadmium::Metaphone,
    soundex:                    Cadmium::SoundEX,
    porter_stemmer:             Cadmium::PorterStemmer,
    aggressive_tokenizer:       Cadmium::AggressiveTokenizer,
    case_tokenizer:             Cadmium::CaseTokenizer,
    pragmatic_tokenizer:        Cadmium::PragmaticTokenizer,
    regex_tokenizer:            Cadmium::RegexTokenizer,
    sentence_tokenizer:         Cadmium::SentenceTokenizer,
    treebank_word_tokenizer:    Cadmium::TreebankWordTokenizer,
    whitespace_tokenizer:       Cadmium::WhitespaceTokenizer,
    word_punctuation_tokenizer: Cadmium::WordPunctuationTokenizer,
    word_tokenizer:             Cadmium::WordTokenizer,
    transliterator:             Cadmium::Transliterator,
    wordnet:                    Cadmium::Wordnet,
  }

  {% for name, mod in MODULES %}
    # Convenience method for accessing `{{ mod }}`
    def {{ name.id }}
      {{ mod }}
    end
  {% end %}
end
