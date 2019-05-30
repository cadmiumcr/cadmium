require "json"
require "yaml"

module Cadmium
  # Native Bayes Classifier
  #
  # This is a native-bayes classifier which used Laplace Smoothing
  class BayesClassifier
    include JSON::Serializable
    include YAML::Serializable

    @[JSON::Field(ignore: true)]
    @[YAML::Field(ignore: true)]
    property tokenizer : Cadmium::Tokenizer = Cadmium::WordTokenizer.new

    # The words to learn from.
    getter vocabulary : Array(String)

    # Number of documents we have learned from.
    getter total_documents : Int32

    # Document frequency table for each of our categories.
    getter doc_count : Hash(String, Int32)

    # For each category, how many total words were
    # mapped to it.
    getter word_count : Hash(String, Int32)

    # Word frequency table for each category.
    getter word_frequency_count : Hash(String, Hash(String, Int32))

    # Category names
    getter categories : Array(String)

    def initialize(tokenizer = nil)
      @tokenizer = tokenizer if tokenizer
      @vocabulary = [] of String
      @total_documents = 0
      @doc_count = {} of String => Int32
      @word_count = {} of String => Int32
      @word_frequency_count = {} of String => Hash(String, Int32)
      @categories = [] of String
    end

    # Intializes each of our data structure entities for this
    # new category and returns `self`.
    def initialize_category(name)
      unless categories.includes?(name)
        categories << name
        doc_count[name] = 0
        word_count[name] = 0
        word_frequency_count[name] = {} of String => Int32
      end
      self
    end

    # Train our native-bayes classifier by telling it what
    # `category` the train `text` corresponds to.
    def train(text, category)
      # Intialize the category if it hasn't already been
      # initialized.
      initialize_category(category)

      # Update our count of how many documents are mapped to
      # this category.
      @doc_count[category] += 1

      # Update the total number of documents we have learned
      # from.
      @total_documents += 1

      # Normalize the text into a word array.
      tokens = @tokenizer.tokenize(text)

      # Get a frequency count for each token in the text.
      freq_table = frequency_table(tokens)

      # Update our vocabulary and our word frequency count
      # for this category.
      freq_table.each do |token, frequency|
        # Add this word to our vocabulary if it isn't already
        # there.
        @vocabulary << token unless vocabulary.includes?(token)

        # Update the frequency information for this word in
        # this category.
        if !@word_frequency_count[category][token]?
          @word_frequency_count[category][token] = frequency
        else
          @word_frequency_count[category][token] += 1
        end

        # Update the count of all words we have seen mapped to
        # this category.
        @word_count[category] += frequency
      end

      self
    end

    # Determines what category the `text` belongs to.
    def categorize(text)
      max_probability = -Float64::INFINITY
      chosen_category = nil

      tokens = tokenizer.tokenize(text)
      freq_table = frequency_table(tokens)

      # Iterate through our categories to find the one with
      # the maximum probability for this text.
      @categories.each do |category|
        # Start out by calculating the overall probability of
        # this category. (out of all the documents we've
        # looked at, how many were mapped to this category)
        category_probability = @doc_count[category].to_f64 / @total_documents.to_f64

        # Take the log to avoid underflow
        log_probability = Math.log(category_probability)

        # Now determine P( w | c ) for each word `w` in the text.
        freq_table.each do |token, frequency_in_text|
          token_prob = token_probability(token, category)

          # Determine the log of the P( w | c ) for this word.
          log_probability += frequency_in_text * Math.log(token_prob)
        end

        if log_probability > max_probability
          max_probability = log_probability
          chosen_category = category
        end
      end

      chosen_category
    end

    # Calculate the probaility that a `token` belongs to
    # a `category`.
    def token_probability(token, category)
      # How many times this word has occured in documents
      # mapped to this category.
      word_freq = @word_frequency_count[category][token]? || 0

      # What is the count of all words that have ever
      # been mapped to this category.
      word_count = @word_count[category]

      # Use Laplace Add-1 Smoothing equation
      (word_freq.to_f64 + 1_f64) / (word_count.to_f64 + @vocabulary.size.to_f64)
    end

    # Build a frequency hash map where
    # - the keys are the entries in `tokens`
    # - the values are the frequency of each entry in `tokens`
    def frequency_table(tokens)
      tokens.reduce({} of String => Int32) do |map, token|
        if map.has_key?(token)
          map[token] += 1
        else
          map[token] = 1
        end
        map
      end
    end
  end
end
