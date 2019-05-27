require "html"

require "./tokenizer_base"
require "./pragmatic/regex"
require "./pragmatic/languages"

require "./pragmatic/pre_processor"
require "./pragmatic/post_processor"

module Cadmium
  module Tokenizer
    # This tokenizer is based off of the [pragmatic_tokenizer]() ruby gem. It is much more robust than any
    # of the other tokenizers, but has more features than you'll need for most use cases.
    #
    # ### Constructor Options
    # - **filter_languages** : `Array` - user-supplied array of languages from which that language's stop words, abbreviations and contractions should be used when calculating the resulting tokens
    # - **language** : `Symbol | String` - two character ISO 639-1 code; can be a String or symbol (default :en)
    # - **expand_contractions** : `Bool` - (default: false)
    # - **remove_stop_words** : `Bool` - (default: false)
    # - **abbreviations** : `Set(String)` - user-supplied array of abbreviations (each element should be downcased with final period removed)
    # - **stop_words** : `Set(String)` - user-supplied array of stop words - array elements should be of the String class
    # - **contractions** : `Hash(String, String)` - user-supplied hash of contractions (key is the contracted form; value is the expanded form - both the key and value should be downcased)
    # - **punctuation** : `PunctuationOptions` - see description below
    #   - `all:` Does not remove any punctuation from the result
    #   - `semi:` Removes common punctuation (such as full stops) and does not remove less common punctuation
    #   (such as questions marks). This is useful for text alignment as less common punctuation can help
    #   identify a sentence (like a fingerprint) while common punctuation (like stop words) should be removed.
    #   - `none:` Removes all punctuation from the result
    #   - `only:` Removes everything except punctuation. The returned result is an array of only the punctuation.
    # - **numbers** : `NumberOptions` - see description below
    #   - `all:` Does not remove any numbers from the result
    #   - `semi:` Removes tokens that include only digits
    #   - `none:` Removes all tokens that include a number from the result (including Roman numerals)
    #   - `only:` Removes everything except tokens that include a number
    # - **minimum_length** : `Int32` - minimum length of the token in characters
    # - **long_word_split** : `Int32` - the specified length to split long words at any hyphen or underscore. 0 = no split (default).
    # - **mentions** : `MentionOptions` - what to do with mentions (such as '@watzon')
    #   - `remove:` will completely remove it
    #   - `keep_and_clean:` will prefix
    #   - `keep_original:` don't alter the token at all (default)
    # - **hashtags** : `HashtagOptions` - what to do with hashtags (such as '#crystal')
    #   - `remove:` will completely remove it,
    #   - `keep_and_clean:` will prefix
    #   - `keep_original:` don't alter the token at all (default)
    # - **downcase** : `Bool` - downcase all tokens (default: true)
    # - **clean** : `Bool` - removes some symbols (default: false)
    # - **classic_filter** : `Bool` - removes dots from acronyms and 's from the end of tokens. [link](# https://lucene.apache.org/solr/guide/6_6/filter-descriptions.html#FilterDescriptions-ClassicFilter) (default: false)
    # - **remove_emoji** : `Bool` - strip emojis (default: false)
    # - **remove_emails** : `Bool` - strip emails (default: false)
    # - **remove_urls** : `Bool` - strip urls (default: false)
    # - **remove_domains** : `Bool` - strip domains (default: false)
    #
    # ### Examples
    #
    # ```
    # tokenizer = Cadmium::Tokenizers::Pragmatic.new
    # tokenizer.tokenize("Hello world.")
    # # => ["hello", "world", "."]
    #
    # tokenizer.tokenize("Jan. 2015 was 20% colder than now. But not in inter- and outer-space.")
    # # => ["jan.", "2015", "was", "20%", "colder", "than", "now", ".", "but", "not", "in", "inter", "-", "and", "outer-space", "."]
    #
    # tokenizer.contractions = {"supa'soo" => "super smooth"}
    # tokenizer.expand_contractions = true
    # tokenizer.tokenize("Hello supa'soo guy.")
    # # => ["hello", "super", "smooth", "guy", "."]
    #
    # tokenizer.clean = true
    # tokenizer.tokenize("This sentence has a long string of dots .......................")
    # # => ["this", "sentence", "has", "a", "long", "string", "of", "dots"]
    # ```
    class Pragmatic
      enum PunctuationOptions
        ALL
        SEMI
        NONE
        ONLY
      end

      enum NumbersOptions
        ALL
        SEMI
        NONE
        ONLY
      end

      enum MentionsOptions
        KEEP_ORIGINAL
        KEEP_AND_CLEAN
        REMOVE
      end

      MAX_TOKEN_LENGTH = 50
      NOTHING          = ""
      DOT              = "."
      SPACE            = " "
      SINGLE_QUOTE     = "'"

      @language_module : Languages::Base.class

      @regex_by_options : ::Regex?

      # Array of output tokens
      getter tokens = [] of String

      # Set of recognized abbreviations
      property abbreviations : Set(String)

      # Contractions to be replaced
      property contractions : Hash(String, String)

      # An array of stop words
      property stop_words : Set(String)

      # Other languages to include in the filtering of abbreviations,
      # contractions, and stop words
      property filter_languages : Array(String | Symbol)

      # What to do with hashtags (`#awesome`)
      property hashtags : MentionsOptions

      # What to do with mentions (`@watzon`)
      property mentions : MentionsOptions

      # What to do with punctuation
      property punctuation : PunctuationOptions

      # What to do with numbers
      property numbers : NumbersOptions

      # Do we want to expand contractions ("he's" => "he is")
      property expand_contractions : Bool

      # Should we remove stop words
      property remove_stop_words : Bool

      # Should we remove emojis
      property remove_emoji : Bool

      # Should we remove emails
      property remove_emails : Bool

      # Should we remove urls
      property remove_urls : Bool

      # Should we remove domains
      property remove_domains : Bool

      # Run the cleaner after we've tokenized?
      property clean : Bool

      # Run the classic filter?
      property classic_filter : Bool

      # Downcase all tokens?
      property downcase : Bool

      # Minimum length for tokens
      property minimum_length : Int32

      # The specified length to split long words at any hyphen or underscore
      property long_word_split : Int32

      # Creates a new Pragmatic tokenizer.
      def initialize(
        *,
        language = :en,
        abbreviations = Set(String).new,
        stop_words = Set(String).new,
        contractions = {} of String => String,
        filter_languages = [] of String | Symbol,
        @hashtags : MentionsOptions = :keep_original,
        @mentions : MentionsOptions = :keep_original,
        @punctuation : PunctuationOptions = :all,
        @numbers : NumbersOptions = :all,
        @expand_contractions = false,
        @remove_stop_words = false,
        @remove_emoji = false,
        @remove_emails = false,
        @remove_urls = false,
        @remove_domains = false,
        @clean = false,
        @classic_filter = false,
        @downcase = true,
        @minimum_length = 0,
        @long_word_split = 0
      )
        @language_module = Languages.get_language_by_code(language)

        @abbreviations = abbreviations.is_a?(Set) ? abbreviations : Set(String).new(abbreviations)
        @stop_words = stop_words.is_a?(Set) ? stop_words : Set(String).new(stop_words)
        @contractions = contractions.is_a?(Hash) ? contractions : contractions.to_h

        @filter_languages = filter_languages.is_a?(Array(String | Symbol)) ? filter_languages : (Array(String | Symbol).new.concat(filter_languages))

        @contractions.merge!(@language_module.contractions)
        @abbreviations.concat @language_module.abbreviations if @abbreviations.empty?
        @stop_words.concat @language_module.stop_words if @stop_words.empty?

        @filter_languages.each do |language|
          language = Languages.get_language_by_code(language)
          @contractions.merge!(language.contractions)
          @abbreviations.concat language.abbreviations
          @stop_words.concat language.stop_words
        end
      end

      def tokenize(text = nil)
        return [] of String unless text

        HTML.unescape(text)
          .scan(Pragmatic::Regex::CHUNK_LONG_INPUT_TEXT)
          .flat_map { |segment| process_segment(segment.string) }
      end

      private def process_segment(segment)
        pre_processed = pre_process(segment)
        cased_segment = chosen_case(pre_processed)
        @tokens = Pragmatic::PostProcessor.new(text: cased_segment, abbreviations: @abbreviations, downcase: @downcase).process
        post_process_tokens
      end

      private def pre_process(segment)
        pre_processor = Pragmatic::PreProcessor.new(@language_module)
        pre_processor.process(segment)
      end

      private def post_process_tokens
        remove_by_options!
        process_numbers!
        process_punctuation!
        expand_contractions! if @expand_contractions
        clean! if @clean
        classic_filter! if @classic_filter
        remove_short_tokens! if @minimum_length > 0
        remove_stop_words! if @remove_stop_words
        mentions!
        hashtags!
        split_long_words! if @long_word_split
        @tokens = @tokens.reject(&.empty?)
      end

      private def expand_contractions!
        @tokens = @tokens.flat_map { |token| expand_token_contraction(token) }
      end

      private def expand_token_contraction(token)
        normalized = inverse_case(token.gsub(Pragmatic::Regex::CONTRACTIONS, SINGLE_QUOTE))
        return token unless @contractions.has_key?(normalized)
        result = @contractions[normalized].split(SPACE)
        result[0] = result[0].capitalize unless @downcase
        result
      end

      private def clean!
        @tokens = @tokens
          .flat_map { |token| split_underscores_asterisk(token) }
          .map! { |token| remove_irrelevant_characters(token) }
          .delete_if { |token| many_dots?(token) }
      end

      private def split_underscores_asterisk(token)
        return token if token =~ Pragmatic::Regex::ONLY_HASHTAG_MENTION
        token.split(Pragmatic::Regex::UNDERSCORES_ASTERISK)
      end

      private def remove_irrelevant_characters(token)
        token = token.gsub(Pragmatic::Regex::IRRELEVANT_CHARACTERS, NOTHING)
        return token if token =~ Pragmatic::Regex::ONLY_HASHTAG_MENTION
        token = token.gsub(Pragmatic::Regex::ENDS_WITH_EXCITED_ONE, NOTHING)
        token
      end

      private def many_dots?(token)
        token =~ Pragmatic::Regex::MANY_PERIODS
      end

      private def classic_filter!
        @tokens.map! do |token|
          token = token.delete(DOT) if @abbreviations.includes?(token.chomp(DOT))
          token = token.sub(Pragmatic::Regex::ENDS_WITH_APOSTROPHE_AND_S, NOTHING)
          token
        end
      end

      private def process_numbers!
        case @numbers
        when NumbersOptions::SEMI
          @tokens.delete_if { |token| token =~ Pragmatic::Regex::ONLY_DECIMALS }
        when NumbersOptions::NONE
          @tokens.delete_if { |token| token =~ Pragmatic::Regex::NO_DECIMALS_NO_NUMERALS }
        when NumbersOptions::ONLY
          @tokens.delete_if { |token| token =~ Pragmatic::Regex::NO_DECIMALS }
        end
      end

      private def remove_short_tokens!
        @tokens.delete_if { |token| token.size < @minimum_length }
      end

      private def process_punctuation!
        case @punctuation
        when PunctuationOptions::SEMI
          @tokens.delete_if { |token| token =~ Pragmatic::Regex::PUNCTUATION4 }
        when PunctuationOptions::NONE
          @tokens.delete_if { |token| token =~ Pragmatic::Regex::ONLY_PUNCTUATION }
        when PunctuationOptions::ONLY
          @tokens.keep_if { |token| token =~ Pragmatic::Regex::ONLY_PUNCTUATION }
        end
      end

      private def remove_stop_words!
        @tokens.delete_if { |token| @stop_words.includes?(inverse_case(token)) }
      end

      private def mentions!
        case @mentions
        when MentionsOptions::REMOVE
          @tokens.delete_if { |token| token =~ Pragmatic::Regex::ONLY_MENTION }
        when MentionsOptions::KEEP_AND_CLEAN
          @tokens.map! { |token| token =~ Pragmatic::Regex::ONLY_MENTION ? token[1..-1] : token }
        end
      end

      private def hashtags!
        case @hashtags
        when MentionsOptions::REMOVE
          @tokens.delete_if { |token| token =~ Pragmatic::Regex::ONLY_HASHTAG }
        when MentionsOptions::KEEP_AND_CLEAN
          @tokens.map! { |token| token =~ Pragmatic::Regex::ONLY_HASHTAG ? token[1..-1] : token }
        end
      end

      private def remove_by_options!
        @tokens.delete_if { |token| token =~ regex_by_options }
      end

      private def regex_by_options
        @regex_by_options ||= begin
          regex_array = [] of ::Regex
          regex_array << Pragmatic::Regex::RANGE_UNUSUAL_AND_EMOJI if @remove_emoji
          regex_array << Pragmatic::Regex::ONLY_EMAIL if @remove_emails
          regex_array << Pragmatic::Regex::STARTS_WITH_HTTP if @remove_urls
          regex_array << Pragmatic::Regex::ONLY_DOMAIN2 if @remove_domains
          ::Regex.union(regex_array) unless regex_array.empty?
        end
      end

      private def split_long_words!
        @tokens = @tokens.flat_map { |token| split_long_word(token) }
      end

      private def split_long_word(token)
        return token unless @long_word_split && @long_word_split != 0
        return token if token.size <= @long_word_split
        return token if token =~ Pragmatic::Regex::ONLY_HASHTAG_MENTION
        return token if token =~ Pragmatic::Regex::DOMAIN_OR_EMAIL
        token.split(Pragmatic::Regex::HYPHEN_OR_UNDERSCORE)
      end

      private def chosen_case(text)
        @downcase ? text.downcase : text
      end

      private def inverse_case(token)
        @downcase ? token : token.downcase
      end
    end
  end
end
