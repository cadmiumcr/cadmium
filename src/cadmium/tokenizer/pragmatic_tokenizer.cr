require "./tokenizer_base"

module Cadmium
  module Tokenizer
    class PragmaticTokenizer < TokenizerBase
      def initialize(
        *,
        lang = :en,
        abbreviations : Array(String)? = nil,
        stop_words : Array(String)? = nil,
        contractions : Array(String)? = nil,
        remove_stop_words = false,
        expand_contractions = false,
        filter_languages : Array(String | Symbol)? = nil,
        punctuation = :all,
        numbers = :all,
        remove_emoji = false,
        remove_urls = false,
        remove_domains = false,
        clean = false,
        hashtags = :keep_original,
        mentions = :keep_original,
        classic_filter = false,
        downcase = true,
        minimum_length = 0,
        long_word_split = nil
      )
      end

      def tokenize(string : String)
      end
    end
  end
end
