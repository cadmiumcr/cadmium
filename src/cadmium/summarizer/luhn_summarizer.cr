require "./summarizer"

module Cadmium
  # The Luhn summarizer returns the most significant sentences of a text by :
  # 1 - Calculating occurences ratio of significant words (discounting ones with ratio outside an arbitray range, ie "normalized").
  # 2 - Calculating each sentence weight ((number of significant words)² / (greatest distance between two significant words)).
  # 3 - Sorting sentences according to their weight and returning the first n of them.
  # Reference : https://ieeexplore.ieee.org/document/5392672?arnumber=5392672
  class LuhnSummarizer < Summarizer
    private def window_start(words_in_sentence : Array(String), keywords : Array(String)) : Int32 | Nil
      words_in_sentence.index { |word| keywords.includes?(word) }
    end

    private def window_end(words_in_sentence : Array(String), keywords : Array(String)) : Int32 | Nil
      words_in_sentence[-1..0].index { |word| keywords.includes?(word) }
    end

    private def window_size(words_in_sentence : Array(String), keywords : Array(String)) : Int32
      return 0 unless (window_start = window_start(words_in_sentence, keywords))
      return 0 unless (window_end = window_end(words_in_sentence, keywords))
      return 0 if window_start.not_nil! > window_end.not_nil!
      window_end.not_nil! - window_start.not_nil! + 1
    end

    private def sentence_weight(sentence : String, normalized_terms : Array(String)) : Int32
      terms_in_sentence = all_terms(sentence)
      return 0 if terms_in_sentence.size <= 1
      window_size = window_size(terms_in_sentence, normalized_terms)
      return 0 if window_size <= 0
      number_of_normalized_terms = terms_in_sentence.count { |word| normalized_terms.includes?(word) }
      (number_of_normalized_terms*number_of_normalized_terms) / window_size
    end

    def summarize(text : String, max_num_sentences = 5) : String
      return "" if max_num_sentences <= 0
      normalized_terms = normalized_terms(text)
      return "" if normalized_terms.nil?
      sentences = Cadmium::Util::Sentence.sentences(text)
      sentences.sort_by! { |sentence| -sentence_weight(sentence, normalized_terms) }
      sentences[0..max_num_sentences].join(" ")
    end
  end
end
