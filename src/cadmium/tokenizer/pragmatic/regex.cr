module Cadmium
  module Tokenizer
    class PragmaticTokenizer
      class Regex
        # Things that can or should be done:
        # - check where the use of unicode categories helps (\p{Abbreviation})
        # - use URI.parse and other libraries instead of regexp to identify urls, domains, emails
        # - check multiple domain regex, we have spec issues when using one or the other
        # - check multiple punctuation regex

        # Text that needs to be tokenized is initially split into chunks of this length:
        CHUNK_LONG_INPUT_TEXT = /\S.{1,10000}(?!\S)/m

        # Ranges
        RANGE_DINGBATS                = /[\x{2701}-\x{27BE}]/ # e.g. ✁✎✳❄➾
        RANGE_VARIATION_SELECTORS     = /[\x{FE00}-\x{FE0F}]/ # alter the previous character
        RANGE_FULLWIDTH               = /[\x{FF01}-\x{fF1F}]/ # e.g. ！＂＃＇？
        RANGE_ALPHANUMERIC_SUPPLEMENT = /[\x{1F100}-\x{1F1FF}]/
        RANGE_UNUSUAL_AND_EMOJI       = /[\x{203C}-\x{3299}\x{1F000}-\x{1F644}]/

        # Regular expressions which do not need to capture anything are enclosed in /(?: … )/ to enhance performance
        COLON1               = /(?:(:)([[:print:]]{2,}))/ # two non-space after colon prevent matching emoticons
        COLON2               = /(?::)/
        COMMAS               = /(?:([,‚])+)/
        ENCLOSED_PLUS        = /(?:([[:print:]]+)\+([[:print:]]+))/
        EMAIL                = /(?:[[:print:]]+[＠@][[:print:]]+\.[[:print:]]+)/
        DIGIT                = /(?:[[:digit:]]+)/
        ASTERISK             = /(?:\*+)/
        UNDERSCORE           = /(?:_+)/
        HYPHEN_OR_UNDERSCORE = /(?:[-_])/
        PERIOD_AND_PRIOR     = /(?:(.+\.))/
        PERIOD_ONLY          = /(?:(\.))/
        CONTRACTIONS         = /(?:[‘’‚‛‹›＇´`])/
        PUNCTUATION1         = /(?:([\p{Pd}\p{Pe}\p{Pf}\p{Pi}\p{Ps}])+)/ # all punctuation categories except Pc (Connector) and Po (other)
        PUNCTUATION2         = /(?:(?<=\S)([!?#{RANGE_FULLWIDTH.source}]+))/
        PUNCTUATION3         = /(?:[!%\-–\x{00AD}]+)/
        PUNCTUATION4         = /(?:[.．。]+)/
        DINGBATS             = /(?:(#{RANGE_DINGBATS.source}#{RANGE_VARIATION_SELECTORS.source}*+))/
        NO_BREAK_SPACE       = /(?:\x{00A0}+)/
        HTTP                 = /(?:https?:\/\/)/
        TIME_WITH_COLON      = /(?:\d:\d)/
        DOMAIN_PREFIX        = /(?:https?:\/\/|www\.|[[:alpha:]]\.)/
        DOMAIN_SUFFIX        = /(?:[[:alpha:]]\.(?:com|net|org|edu|gov|mil|int|[[:alpha:]]{2}))/
        DOMAIN1              = /(?:((https?:\/\/|)[[:print:]]+\.[[:alpha:]]{2,6}(:[0-9]{1,5})?(\/[[:print:]]*+)?))/
        DOMAIN2              = /(?:[[:alnum:]]{2,}([\-.][[:alnum:]]+)*\.[[:alpha:]]{2,6}(:[0-9]{1,5})?(\/[[:print:]]*+)?)/
        NOT_URL              = /(?:^(?!#{DOMAIN_PREFIX.source})([[:print:]]*))/
        HASHTAG_OR_MENTION   = /(?:[@#＠＃][[:print:]]+)/
        HASHTAG              = /(?:[#＃][[:print:]]+)/
        MENTION              = /(?:[@＠][[:print:]]+)/
        HASHTAG_WITH_HYPHEN  = /(?:^([#＃][[:digit:]]+)-)/
        ONE_AS_EXCLAMATION   = /(?:\D1+)/
        ONES_EXCLAMATIONS    = /(?:!+(1*+!*+)*+)/
        MANY_PERIODS         = /(?:^\.{2,}$)/
        COPYRIGHT_TRADEMARK  = /(?:[®©™]+)/
        CONTROL_CHARACTER    = /(?:[[:cntrl:]]+)/ # matches any character with hexadecimal value 00 through 1F or 7F.
        APOSTROPHE_AND_S     = /(?:['’`́]s)/
        ALSO_DECIMALS        = /(?:[[:alpha:]]*+[[:digit:]]+)/
        ACUTE_ACCENT_S       = /(?:\s\x{0301}(?=s))/

        # Regular expressions used to capture items
        CAPTURE_UNUSUAL_AND_EMOJI = /(#{RANGE_UNUSUAL_AND_EMOJI.source})/
        QUESTION_MARK_NOT_URL     = /#{NOT_URL.source}(\?)/
        # Should we change specs and also capture "/", just like we capture ":" and "?"
        SLASH_NOT_URL             = /#{NOT_URL.source}\//
        SHIFT_BOUNDARY_CHARACTERS = /([;^&|…«»„“¿¡≠]+)/
        MULTIPLE_DOTS             = /(\.{2,})/ # we keep all dashes
        MULTIPLE_DASHES           = /(-){2,}/  # we only keep first dash
        BRACKET                   = /([{}()\[\]])/
        EXCLAMATION_BETWEEN_ALPHA = /(?<=[[:alpha:]])(!)(?=[[:alpha:]])/
        PERCENT_BEFORE_DIGIT      = /(%)\d+/
        COMMA_BEFORE_NON_DIGIT    = /(,)(?=\D)/
        COMMA_AFTER_NON_DIGIT     = /(?<=\D)(,)/
        COLON_IN_URL              = /(?<=[(https?|ftp)]):(?=\/\/)/
        QUOTE_BEFORE_PRINT        = /(('')|["“])(?=[[:print:]])/
        QUOTE                     = /('')|["”]/
        HYPHEN_AFTER_NON_WORD     = /(?<=\W)(-)/
        HYPHEN_BEFORE_NON_WORD    = /(-)(?=\W)/

        STARTS_WITH_COMMAS       = /^#{COMMAS.source}/
        STARTS_WITH_HTTP         = /^#{HTTP.source}/
        STARTS_WITH_DOMAIN       = /^#{DOMAIN_PREFIX.source}/
        STARTS_WITH_COLON1       = /^#{COLON1.source}/
        STARTS_WITH_UNDERSCORE   = /^#{UNDERSCORE.source}/
        STARTS_WITH_PUNCTUATION3 = /^#{PUNCTUATION3.source}/

        ENDS_WITH_DOMAIN            = /#{DOMAIN_SUFFIX.source}$/
        ENDS_WITH_PUNCTUATION1      = /#{PUNCTUATION1.source}$/
        ENDS_WITH_PUNCTUATION2      = /#{PUNCTUATION2.source}$/
        ENDS_WITH_COLON2            = /#{COLON2.source}$/
        ENDS_WITH_UNDERSCORE        = /#{UNDERSCORE.source}$/
        ENDS_WITH_ONES_EXCLAMATIONS = /#{ONES_EXCLAMATIONS.source}$/
        ENDS_WITH_EXCITED_ONE       = /#{ONE_AS_EXCLAMATION.source}$/
        ENDS_WITH_APOSTROPHE_AND_S  = /#{APOSTROPHE_AND_S.source}$/
        ENDS_WITH_ALPHA             = /[[:alpha:]]$/
        ENDS_WITH_DIGIT             = /[[:digit:]]$/

        ONLY_DECIMALS           = /(?:^[[:digit:]]+$)/
        NO_DECIMALS             = /(?:^\D+$)/
        ONLY_PUNCTUATION        = /^[[[:punct:]]^\|+]+$/
        ONLY_ROMAN_NUMERALS     = /^(?=[MDCLXVI])M*(C[MD]|D?C*)(X[CL]|L?X*)(I[XV]|V?I*)$/i
        ONLY_EMAIL              = /^#{EMAIL}$/
        ONLY_HASHTAG_MENTION    = /^#{HASHTAG_OR_MENTION}$/
        ONLY_HASHTAG            = /^#{HASHTAG}$/
        ONLY_MENTION            = /^#{MENTION}$/
        ONLY_DOMAIN1            = /^#{DOMAIN1}$/
        ONLY_DOMAIN2            = /^#{DOMAIN2}$/
        ONLY_DOMAIN3            = Regexp.union(STARTS_WITH_DOMAIN, ENDS_WITH_DOMAIN)
        DOMAIN_OR_EMAIL         = Regexp.union(ONLY_DOMAIN1, ONLY_EMAIL)
        UNDERSCORES_ASTERISK    = Regexp.union(STARTS_WITH_UNDERSCORE, ENDS_WITH_UNDERSCORE, ASTERISK)
        NO_DECIMALS_NO_NUMERALS = Regexp.union(ALSO_DECIMALS, ONLY_ROMAN_NUMERALS)

        COMMAS_OR_PUNCTUATION = Regexp.union(
          STARTS_WITH_COMMAS,
          ENDS_WITH_PUNCTUATION1,
          ENDS_WITH_PUNCTUATION2
        )

        # Can this constant name be clarified?
        VARIOUS = Regexp.union(
          SLASH_NOT_URL,
          QUESTION_MARK_NOT_URL,
          ENCLOSED_PLUS,
          STARTS_WITH_COLON1,
          DINGBATS,
          HASHTAG_WITH_HYPHEN,
          CAPTURE_UNUSUAL_AND_EMOJI
        )

        IRRELEVANT_CHARACTERS = Regexp.union(
          STARTS_WITH_PUNCTUATION3,
          ENDS_WITH_COLON2,
          ENDS_WITH_ONES_EXCLAMATIONS,
          CONTROL_CHARACTER,
          COPYRIGHT_TRADEMARK,
          RANGE_ALPHANUMERIC_SUPPLEMENT
        )

        PRE_PROCESS = Regexp.union(
          SHIFT_BOUNDARY_CHARACTERS,
          MULTIPLE_DOTS,
          BRACKET,
          MULTIPLE_DASHES,
          EXCLAMATION_BETWEEN_ALPHA,
          PERCENT_BEFORE_DIGIT,
          COMMA_BEFORE_NON_DIGIT,
          COMMA_AFTER_NON_DIGIT
        )
      end
    end
  end
end
