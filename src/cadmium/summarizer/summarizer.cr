module Cadmium
  abstract class Summarizer
    abstract def summarize(text : String, max_num_sentences = 5) : String

    def all_terms(text : String) : Array(String)
      text.tokenize(WordTokenizer)
    end

    def significant_terms(text : String) : Array(String) # Should we use a stemmer ?
      PragmaticTokenizer.new(
        clean: true,
        remove_stop_words: true,
        punctuation: :none,
        downcase: true
      ).tokenize(text)
    end

    def normalized_terms_ratio(text : String, min_ratio = 0.001, max_ratio = 0.5) : Hash(String, Float64) | Nil
      number_of_terms = all_terms(text).size
      return nil if number_of_terms == 0
      significant_terms = significant_terms(text)
      return nil if significant_terms.size == 0
      normalize_ratio(terms_ratio(terms_frequencies(significant_terms), number_of_terms), min_ratio, max_ratio) # This is ugly, should find a better way to chain.
    end

    def normalized_terms(text : String, min_ratio = 0.001, max_ratio = 0.5) : Array(String) | Nil
      return nil unless normalized_terms = normalized_terms_ratio(text, min_ratio, max_ratio)
      normalized_terms.keys
    end

    def terms_frequencies(terms : Array(String)) : Hash(String, Int32) # Should we use Cadmium Tf instead ? Maybe factor it out in Cadmium::Util ?
      terms_frequencies = {} of String => Int32

      terms.each do |term|
        terms_frequencies.has_key?(term) ? (terms_frequencies[term] += 1) : (terms_frequencies[term] = 1)
      end
      terms_frequencies
    end

    def terms_ratio(terms_frequencies : Hash(String, Int32), number_of_terms : Int32) : Hash(String, Float64) # Is ratio the same as idf ?
      terms_ratio = {} of String => Float64
      terms_frequencies.keys.each do |term|
        ratio = terms_frequencies[term].to_f / number_of_terms
        terms_ratio[term] = ratio # unless (ratio < min_ratio || ratio > max_ratio)
      end
      terms_ratio
    end

    def normalize_ratio(terms_ratio : Hash(String, Float64), min_ratio = 0.001, max_ratio = 0.5) : Hash(String, Float64) # Should we make min_ratio and max_ratio configurable by the user ?
      terms_ratio.delete_if { |_, ratio| !(min_ratio..max_ratio).includes?(ratio) }
    end
  end
end
