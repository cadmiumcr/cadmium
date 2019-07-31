module Cadmium
  abstract class Summarizer
    abstract def summarize(text : String, max_num_sentences = 5) : String

    # The following algo is faster than the pragmatic tokenizer but is the loss of quality output put worth it ?
    # Taken from the Readability class. Should we replace it there by a proper tokenizer ?
    # def all_words(text)
    #   all_words = [] of String
    #   text.scan(/\b([a-z][a-z\-']*)\b/i).each do |match|
    #     word = match[0]
    #     all_words << word
    #   end
    #   all_words
    # end

    def all_words(text : String) : Array(String)
      Cadmium::PragmaticTokenizer.new(
        clean: true,
        remove_stop_words: false,
        punctuation: :none,
        downcase: true
      ).tokenize(text)
    end

    def significant_words(text : String) : Array(String) # Should we add a stemmer ?
      Cadmium::PragmaticTokenizer.new(
        clean: true,
        remove_stop_words: true,
        punctuation: :none,
        downcase: true
      ).tokenize(text)
    end
  end
end
