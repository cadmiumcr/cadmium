# require "./summarizer"

# module Cadmium
#   # The KL Sum method greedily adds sentences to a summary so long as it decreases the KL Divergence.
#   # Reference : https://www.aclweb.org/anthology/N09-1041
#   class KLSummarizer < Summarizer
#     def keywords(text, min_ratio = 0.001, max_ratio = 0.5) # Should we make min_ratio and max_ratio configurable by the user ?
#       number_of_words = all_words(text).size
#       return nil if number_of_words == 0
#       significant_words = significant_words(text)
#       return nil if significant_words.size == 0

#       keywords_occurences = {} of String => Int32
#       keywords_ratio = {} of String => Float64

#       significant_words.each do |word| # Should we use Cadmium Tf instead ?
#         keywords_occurences.has_key?(word) ? (keywords_occurences[word] += 1) : (keywords_occurences[word] = 1)
#       end

#       keywords_occurences.keys.each do |word|
#         ratio = keywords_occurences[word].to_f / number_of_words
#         keywords_ratio[word] = ratio unless (ratio < min_ratio || ratio > max_ratio)
#       end

#       keywords_ratio.keys
#     end

#     private def window_start(words_in_sentence : Array(String), keywords : Array(String)) : Int32 | Nil
#       words_in_sentence.index { |word| keywords.includes?(word) }
#     end

#     private def window_end(words_in_sentence : Array(String), keywords : Array(String)) : Int32 | Nil
#       words_in_sentence[-1..0].index { |word| keywords.includes?(word) }
#     end

#     private def window_size(words_in_sentence : Array(String), keywords : Array(String)) : Int32
#       return 0 unless (window_start = window_start(words_in_sentence, keywords))
#       return 0 unless (window_end = window_end(words_in_sentence, keywords))
#       return 0 if window_start.not_nil! > window_end.not_nil!
#       window_end.not_nil! - window_start.not_nil! + 1
#     end

#     private def sentence_weight(sentence : String, keywords : Array(String)) : Int32
#       words_in_sentence = all_words(sentence)
#       return 0 if words_in_sentence.size <= 1
#       window_size = window_size(words_in_sentence, keywords)
#       return 0 if window_size <= 0
#       number_of_keywords = words_in_sentence.count { |word| keywords.includes?(word) }
#       (number_of_keywords*number_of_keywords) / window_size
#     end

#     def summarize(text : String, max_num_sentences = 5) : String
#       return "" if max_num_sentences <= 0
#       keywords = keywords(text)
#       return "" if keywords.nil?
#       sentences = Cadmium::Util::Sentence.sentences(text)
#       sentences.sort_by! { |sentence| -sentence_weight(sentence, keywords) }
#       sentences[0..max_num_sentences].join(" ")
#     end
#   end
# end
