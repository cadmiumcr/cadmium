module Cadmium
  abstract class Summarizer
    abstract def summarize(text : String, max_num_sentences = 5) : Array(String)

    def all_words(text) # Should we use a tokenizer instead ?
      all_words = [] of String
      text.scan(/\b([a-z][a-z\-']*)\b/i).each do |match|
        word = match[0]
        all_words << word
      end
      all_words
    end

    def significant_words(text) # Should we add a stemmer ?
      Cadmium::PragmaticTokenizer.new(
        clean: true,
        remove_stop_words: true,
        punctuation: :none,
        downcase: true
      ).tokenize(text)
    end
  end
end
