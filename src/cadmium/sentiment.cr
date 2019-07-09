module Cadmium
  # Uses sentiment analysis to score a sentence's "feeling". `Cadmium::Sentiment`
  # also takes advantage of emojis to further increase accuracy.
  module Sentiment
    extend self

    # Negate the next word in the phrase.
    NEGATORS = {
      "cant"    => 1,
      "can't"   => 1,
      "dont"    => 1,
      "don't"   => 1,
      "doesnt"  => 1,
      "doesn't" => 1,
      "not"     => 1,
      "non"     => 1,
      "wont"    => 1,
      "won't"   => 1,
      "isnt"    => 1,
      "isn't"   => 1,
      "wasnt"   => 1,
      "wasn't"  => 1,
    }

    # Manage the `Tokenizer` that the sentiment analyzer uses.
    class_property tokenizer : Cadmium::Tokenizer = Cadmium::TreebankWordTokenizer.new

    # Set the sentiment data. Format should look like:
    #
    # ```
    # convince	1
    # cover-up	-3
    # cramp	-1
    # ```
    #
    # Where higher numbers are more positive, lower
    # numbers are more negative, and 0 is neutral.
    class_setter data : String?

    # Gets the raw sentiment data.
    def self.sentiment_data
      @@data ||= {{ read_file("./data/sentiment.txt") }}
    end

    # Analyze a phrase and return a `result` hash comprised of a score,
    # comparative analysis (a score based soley on number of negative
    # and positive words), tokens, words, positive (positive words),
    # and negative (negative words).
    #
    # ```
    # pp Cadmium::Sentiment.analyze("You are a piece of 💩")
    # # => {score: -1,
    # #     comparative: -1,
    # #     tokens: ["You", "are", "a", "piece", "of", "💩"],
    # #     words: ["💩"],
    # #     positive: [],
    # #     negative: ["💩"]}
    # ```
    def analyze(phrase, inject = nil)
      # Turn our text file into an array
      data = self.sentiment_data.split("\n").map do |d|
        arr = d.split(/\s+/).reject(&.empty?)
        str = [] of String
        int = 1
        arr.each do |item|
          if item.to_i { nil }
            int = item
          else
            str.push item
          end
        end
        [str.join(" "), int]
      end.reject(&.empty?)

      case inject
      when Array
        data += inject
      when Hash, NamedTuple
        data = inject.to_h.merge(data)
      end

      # Turn our data array into a hash if it isn't one already
      data = data.to_h

      tokens = @@tokenizer.tokenize(phrase)
      score = 0
      words = [] of String
      positive = [] of String
      negative = [] of String

      (0..tokens.size - 1).each do |i|
        obj = tokens[i]
        item = data[obj]? ? data[obj].to_i : nil
        next unless item

        if i > 0
          prev_token = tokens[i - 1]
          item = -item if NEGATORS.includes?(prev_token)
        end

        words.push(obj)
        positive.push(obj) if item > 0
        negative.push(obj) if item < 0

        score += item
      end

      result = {
        score:       score,
        comparative: tokens.size > 0 ? score / tokens.size : 0,
        tokens:      tokens,
        words:       words,
        positive:    positive,
        negative:    negative,
      }

      result
    end
  end

  module StringExtension
    # Get the sentiment of a string. Same as running
    # `Cadmium::Sentiment.analyze(STRING)`.
    def sentiment(inject = nil)
      Cadmium::Sentiment.analyze(self, inject)
    end

    # Determines if a string is more positive than negative.
    # Returns `Bool`.
    def is_positive?
      sentiment = self.sentiment
      sentiment[:positive] > sentiment[:negative]
    end

    # Determines if a string is more negative than positive.
    # Returns `Bool`.
    def is_negative?
      sentiment = self.sentiment
      sentiment[:negative] > sentiment[:positive]
    end
  end
end
