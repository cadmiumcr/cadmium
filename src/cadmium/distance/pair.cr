module Cadmium
  class PairDistance
    # Uses Dice's Coefficient to get the similarity between two words,
    # or sentences.
    def self.distance(s1 : String, s2 : String)
      ngrams = Cadmium.ngrams.new(tokenizer: Cadmium::VisibleCharTokenizer.new)
      s1bigrams = ngrams.bigrams(s1)
      s2bigrams = ngrams.bigrams(s2)

      longest, shortest = s1bigrams.size >= s2bigrams.size ? [s1bigrams, s2bigrams] : [s2bigrams, s1bigrams]
      intersections = longest.reduce(0) { |acc, i| shortest.includes?(i) ? acc + 1 : acc }
      (2 * intersections).to_f64 / (s1bigrams.size + s2bigrams.size).to_f64
    end
  end
end
