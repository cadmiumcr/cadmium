require "./summarizer"

module Cadmium
  # SumBasic (Nenkova and Vanderwende, 2005) is a system that produces generic multi-document summaries.
  # Its  design  is  motivated  by  the  observation  that  terms  occurring  frequently  in  the  document  cluster  occur with higher probability in the human summaries than words occurring less frequently.
  # Step 1 : Calculate the probability ( = normalized ratio) of each term in the document.
  # Step 2 : Calculate for each sentence in the document a rating equals to the average probability of the terms in the sentence.
  # Step 3 : Pick the best scoring sentence that contains the highest probability word.
  # Step 4 : For each term in the sentence chosen at step 3, update their probability (probability²)
  # Step 5 : If the desired summary length has not been reached, go back to Step 2
  # Reference : http://www.cis.upenn.edu/~nenkova/papers/ipm.pdf
  class SumBasic < Summarizer
    private def average_probability_of_words(normalized_terms_ratio, sentence) # Step 2
      significant_terms_in_sentence = significant_terms(sentence)
      number_of_terms_in_sentence = significant_terms_in_sentence.size
      return 0 if number_of_terms_in_sentence < 1
      sum_of_terms_probability = normalized_terms_ratio.sum { |term| significant_terms_in_sentence.includes?(term) } # Poor performance expected. To be improved
      sum_of_terms_probability / number_of_terms_in_sentence
    end

    private def highest_scoring_sentence_with_highest_probability_term(normalized_terms_ratio, rated_sentences)
      highest_probability_term = normalized_terms_ratio.max_by { |_, ratio| ratio }
      rated_sentences.sort_by! { |_, score| score }
      rated_sentences.index { |sentence| sentence.includes?(highest_probability_term) }
    end

    private def update_probability_of_terms(normalized_terms_ratio, terms_to_update)
      terms_to_update.each do |term|
        normalized_terms_ratio[term] *= normalized_terms_ratio[term]
      end
      normalized_terms_ratio
    end

    private def select_sentences(text, max_num_sentences, normalized_terms_ratio)
      sentences = Cadmium::Util::Sentence.sentences(text)
      selected_sentences = Array(String)
      until selected_sentences.size == max_num_sentences                                                                               # Step 5
        rated_sentences = sentences.map { |sentence| [sentence, average_probability_of_words(normalized_terms_ratio, sentence)] }.to_h # Step 2
        selected_sentence = highest_scoring_sentence_with_highest_probability_term(normalized_terms_ratio, rated_sentences)            # Step 3
        selected_sentences[] = selected_sentence
        update_probability_of_terms(normalized_terms_ratio, significant_terms(selected_sentence)) # Step 4
      end
      selected_sentences
    end

    def summarize(text : String, max_num_sentences = 5) : String
      return "" if max_num_sentences <= 0
      normalized_terms_ratio = normalized_terms_ratio(text) # Step 1
      return "" if normalized_terms_ratio.nil?
      select_sentences(text, max_num_sentences, normalized_terms_ratio)
      #   sentences.sort_by! { |sentence| -sentence_rating(sentence, normalized_terms_ratio) }
      #   sentences[0..max_num_sentences].join(" ")
    end
  end
end
