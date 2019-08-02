# require "./summarizer"

# module Cadmium
#   # The KL Sum method greedily adds sentences to a summary so long as it decreases the KL Divergence.
#   # Reference : https://www.aclweb.org/anthology/N09-1041
#   class KLSummarizer < Summarizer
#     private def window_start(terms_in_sentence : Array(String), normalized_terms : Array(String)) : Int32 | Nil
#       terms_in_sentence.index { |term| normalized_terms.includes?(term) }
#     end

#     private def window_end(terms_in_sentence : Array(String), normalized_terms : Array(String)) : Int32 | Nil
#       terms_in_sentence[-1..0].index { |term| normalized_terms.includes?(term) }
#     end

#     private def window_size(terms_in_sentence : Array(String), normalized_terms : Array(String)) : Int32
#       return 0 unless (window_start = window_start(terms_in_sentence, normalized_terms))
#       return 0 unless (window_end = window_end(terms_in_sentence, normalized_terms))
#       return 0 if window_start.not_nil! > window_end.not_nil!
#       window_end.not_nil! - window_start.not_nil! + 1
#     end

#     private def sentence_rating(sentence : String, normalized_terms_ratio : Hash(String, Float64)) : Int32
#       terms_in_sentence = all_terms(sentence)
#       return 0 if terms_in_sentence.size <= 1
#       normalized_terms = normalized_terms_ratio.keys
#       window_size = window_size(terms_in_sentence, normalized_terms)
#       return 0 if window_size <= 0
#       number_of_normalized_terms = terms_in_sentence.count { |term| normalized_terms.includes?(term) }
#       (number_of_normalized_terms*number_of_normalized_terms) / window_size
#     end
#   end
# end
