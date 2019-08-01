module Cadmium
  abstract class Summarizer
    abstract def summarize(text : String, max_num_sentences = 5) : String

    def all_words(text : String) : Array(String)
      text.tokenize(WordTokenizer)
    end

    def significant_words(text : String) : Array(String) # Should we add a stemmer ?
      PragmaticTokenizer.new(
        clean: true,
        remove_stop_words: true,
        punctuation: :none,
        downcase: true
      ).tokenize(text)
    end
  end
end
