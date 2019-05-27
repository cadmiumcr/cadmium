module Cadmium
  module Tokenizer
    class Pragmatic
      # :nodoc:
      class PostProcessor
        DOT = "."

        getter text : String

        getter abbreviations : Set(String)

        getter downcase : Bool

        def initialize(@text : String, @abbreviations : Set(String), @downcase : Bool)
        end

        def process
          text
            .split
            .map { |token| convert_sym_to_punct(token) }
            .flat_map { |token| token.split(Regex::COMMAS_OR_PUNCTUATION) }
            .flat_map { |token| token.split(Regex::VARIOUS) }
            .flat_map { |token| token.split(Regex::ENDS_WITH_PUNCTUATION2) }
            .flat_map { |token| split_dotted_email_or_digit(token) }
            .flat_map { |token| split_abbreviations(token) }
            .flat_map { |token| split_period_after_last_word(token) }
        end

        private def convert_sym_to_punct(token)
          Languages::Common::PUNCTUATION_MAP.each do |pattern, replacement|
            orig = token
            token = token.sub(replacement, pattern)
            break unless token == orig
          end
          token
        end

        # Per specs, "16.1. day one,17.2. day two" will result in ["16.1", ".",…]. Do we really want that?
        private def split_dotted_email_or_digit(token)
          return token unless token.ends_with?(DOT) && token.size > 1
          shortened = token.chomp(DOT)
          return [shortened, DOT] if shortened =~ Regex::DOMAIN_OR_EMAIL
          return [shortened, DOT] if shortened =~ Regex::ENDS_WITH_DIGIT
          token
        end

        private def split_abbreviations(token)
          return token unless token.includes?(DOT) && token.size > 1
          return token if token =~ Regex::DOMAIN_OR_EMAIL
          abbreviation = extract_abbreviation(token)
          return token.split(Regex::PERIOD_AND_PRIOR) if abbreviations.includes?(abbreviation)
          token
        end

        private def split_period_after_last_word(token)
          return token if token.count(DOT) > 1
          return token if token =~ Regex::ONLY_DOMAIN3
          return token if token =~ Regex::DIGIT
          abbreviation = extract_abbreviation(token)
          return token.split(Regex::PERIOD_ONLY) unless abbreviations.includes?(abbreviation)
          token
        end

        private def extract_abbreviation(token)
          if index = token.index(DOT)
            before_first_dot = token[0, index]
          end

          if before_first_dot.nil?
            token
          else
            downcase ? before_first_dot : before_first_dot.downcase
          end
        end
      end
    end
  end
end
