require "./regex"

module Cadmium
  module Tokenizer
    class Pragmatic
      # :nodoc:
      class PreProcessor
        @replacements_for_quotes : Hash(String, String)?

        def initialize(@language_module : Languages::Common.class)
        end

        def process(segment)
          segment = remove_non_breaking_space!(segment)
          segment = shift_various_characters!(segment)
          segment = replace_colon_in_url!(segment)
          segment = shift_remaining_colons!(segment)
          segment = shift_hashtag!(segment)
          segment = convert_double_quotes!(segment)
          segment = convert_single_quotes!(segment)
          segment = convert_acute_accent_s!(segment)
          segment = shift_hyphens!(segment)
          segment.squeeze(' ')
        end

        def remove_non_breaking_space!(segment)
          segment.gsub(Regex::NO_BREAK_SPACE, "")
        end

        def shift_various_characters!(segment)
          segment.gsub(Regex::PRE_PROCESS, " \\1 \\2 \\3 \\4 \\5 \\6 \\7 \\8 \\9 ")
        end

        def replace_colon_in_url!(segment)
          segment.gsub(Regex::COLON_IN_URL, replacement_for_key(":"))
        end

        def shift_remaining_colons!(segment)
          return segment.gsub(":", " :") if segment !~ Regex::TIME_WITH_COLON
          segment
        end

        def shift_hashtag!(segment)
          segment.gsub("#", " #")
        end

        def convert_double_quotes!(segment)
          segment.gsub(Regex::QUOTE, replacements_for_quotes)
        end

        def replacements_for_quotes
          @replacements_for_quotes ||= {
            "''" => " #{replacement_for_key("\"")} ",
            "\"" => " #{replacement_for_key("\"")} ",
            "“"  => " #{replacement_for_key("“")} ",
          }
        end

        def convert_single_quotes!(segment)
          @language_module.handle_single_quotes(segment)
        end

        def convert_acute_accent_s!(segment)
          segment.gsub(Regex::ACUTE_ACCENT_S, replacement_for_key("`"))
        end

        # can these two regular expressions be merged somehow?
        def shift_hyphens!(segment)
          segment.gsub(Regex::HYPHEN_AFTER_NON_WORD, " - ")
            .gsub(Regex::HYPHEN_BEFORE_NON_WORD, " - ")
        end

        def replacement_for_key(replacement_key)
          Pragmatic::Languages::Common::PUNCTUATION_MAP[replacement_key]
        end
      end
    end
  end
end
