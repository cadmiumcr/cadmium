require "./summarizer"

module Cadmium
  # The Luhn summarizer returns the most significant sentences of a text.
  # Reference : https://ieeexplore.ieee.org/document/5392672?arnumber=5392672
  class LuhnSummarizer < Summarizer
    def keywords(text, min_ratio = 0.001, max_ratio = 0.5) # Should we make min_ratio and max_ratio configurable by the user ?
      number_of_words = all_words(text).size
      keywords_occurences = {} of String => Int32
      keywords_ratio = {} of String => Float64
      significant_words(text).each do |word| # Should we use Cadmium Tf instead ?
        keywords_occurences.has_key?(word) ? (keywords_occurences[word] += 1) : (keywords_occurences[word] = 1)
      end

      keywords_occurences.keys.each do |word|
        ratio = keywords_occurences[word].to_f / number_of_words
        keywords_ratio[word] = ratio unless (ratio < min_ratio || ratio > max_ratio)
      end

      keywords_ratio.keys
    end

    def sentence_weight(sentence, keywords)
      words_in_sentence = sentence.split(' ') # TODO? : Find a Cadmium and more robust way to get words.
      last_index = words_in_sentence.size - 1
      window_start = words_in_sentence.index { |word| keywords.includes?(word) }
      return 0 if window_start === nil
      window_end = words_in_sentence[last_index..0].index { |word| keywords.includes?(word) }
      return 0 if window_start.not_nil! > window_end.not_nil!
      window_size = window_end.not_nil! - 1 + window_start.not_nil!
      number_of_keywords = words_in_sentence.count { |word| keywords.includes?(word) }
      (number_of_keywords*number_of_keywords) / window_size
    end

    def summarize(text : String, max_num_sentences = 5) : Array(String)
      sentences = Cadmium::Util::Sentence.sentences(text)
      sentences.sort_by! { |sentence| -sentence_weight(sentence, keywords(text)) }
      sentences[0..max_num_sentences].join(" ")
    end
  end
end
