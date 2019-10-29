require "./summarizer"

module Cadmium
  # The Luhn summarizer returns the most significant sentences of a text by :
  # 1 - Calculating frequencies ratio of significant terms (discounting ones with ratio outside an arbitray range, ie "normalized").
  # 2 - Calculating each sentence rating ((number of significant terms)² / (greatest distance between two significant terms)).
  # 3 - Sorting sentences according to their weight and returning the first n of them.
  # Reference : https://ieeexplore.ieee.org/document/5392672?arnumber=5392672
  class LuhnSummarizer < Summarizer
    private def all_terms(text : String) : Array(String) # Only for Luhn to calculate term distance in sentence
      text.tokenize(WordTokenizer)
    end

    private def window_start(terms_in_sentence : Array(String), normalized_terms : Array(String)) : Int32 | Nil
      terms_in_sentence.index { |term| normalized_terms.includes?(term) }
    end

    private def window_end(terms_in_sentence : Array(String), normalized_terms : Array(String)) : Int32 | Nil
      terms_in_sentence[-1..0].index { |term| normalized_terms.includes?(term) }
    end

    private def window_size(terms_in_sentence : Array(String), normalized_terms : Array(String)) : Int32
      return 0 unless (window_start = window_start(terms_in_sentence, normalized_terms))
      return 0 unless (window_end = window_end(terms_in_sentence, normalized_terms))
      return 0 if window_start.not_nil! > window_end.not_nil!
      window_end.not_nil! - window_start.not_nil! + 1
    end

    private def sentence_rating(sentence : String, normalized_terms_ratio : Hash(String, Float64)) : Int32
      terms_in_sentence = all_terms(sentence)
      return 0 if terms_in_sentence.size <= 1
      normalized_terms = normalized_terms_ratio.keys
      window_size = window_size(terms_in_sentence, normalized_terms)
      return 0 if window_size <= 0
      number_of_normalized_terms = terms_in_sentence.count { |term| normalized_terms.includes?(term) }
      (number_of_normalized_terms*number_of_normalized_terms) // window_size
    end

    private def select_sentences(text, max_num_sentences, normalized_terms_ratio) : Array(String)
      sentences = Cadmium::Util::Sentence.sentences(text)
      sentences.sort_by! { |sentence| -sentence_rating(sentence, normalized_terms_ratio) } # This could be improved, performance wise.
      sentences[0..max_num_sentences]
    end
  end
end
