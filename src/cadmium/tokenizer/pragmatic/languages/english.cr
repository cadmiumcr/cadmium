require "./common"

module Cadmium
  class PragmaticTokenizer < Tokenizer
    module Languages
      class English < Languages::Common
        include Cadmium::I18n::StopWords
        stop_words en
        ABBREVIATIONS = Set.new(%w[adj adm adv al ala alta apr arc ariz ark art assn asst attys aug ave bart bld bldg blvd brig bros btw cal calif capt cl cmdr co col colo comdr con conn corp cpl cres ct d.phil dak dec del dept det dist dr dr.phil dr.philos drs e.g ens esp esq etc exp expy ext feb fed fla ft fwy fy ga gen gov hon hosp hr hway hwy i.e i.b.m ia id ida ill inc ind ing insp jan jr jul jun kan kans ken ky la lt ltd maj man mar mass may md me med messrs mex mfg mich min minn miss mlle mm mme mo mont mr mrs ms msgr mssrs mt mtn neb nebr nev no nos nov nr oct ok okla ont op ord ore p pa pd pde penn penna pfc ph ph.d pl plz pp prof pvt que rd ref rep reps res rev rt sask sec sen sens sep sept sfc sgt sr st supt surg tce tenn tex u.s u.s.a univ usafa ut v va ver vs vt wash wis wisc wy wyo yuk])
        STOP_WORDS    = stop_words_en
        # N.B. Some English contractions are ambigous (i.e. "she's" can mean "she has" or "she is").
        # Pragmatic Tokenizer will return the most frequently appearing expanded contraction. Regardless, this should
        # be rather insignificant as in most cases one is probably removing stop words.
        CONTRACTIONS = {
          "i'm"               => "i am",
          "i'll"              => "i will",
          "i'd"               => "i would",
          "i've"              => "i have",
          "you're"            => "you are",
          "you'll"            => "you will",
          "you'd"             => "you would",
          "you've"            => "you have",
          "he's"              => "he is",
          "he'll"             => "he will",
          "he'd"              => "he would",
          "she's"             => "she is",
          "she'll"            => "she will",
          "she'd"             => "she would",
          "it's"              => "it is",
          "'tis"              => "it is",
          "it'll"             => "it will",
          "it'd"              => "it would",
          "let's"             => "let us",
          "we're"             => "we are",
          "we'll"             => "we will",
          "we'd"              => "we would",
          "we've"             => "we have",
          "they're"           => "they are",
          "they'll"           => "they will",
          "they'd"            => "they would",
          "they've"           => "they have",
          "there'd"           => "there would",
          "there'll"          => "there will",
          "there're"          => "there are",
          "there's"           => "there has",
          "there've"          => "there have",
          "that's"            => "that is",
          "that'll"           => "that will",
          "that'd"            => "that would",
          "who's"             => "who is",
          "who'll"            => "who will",
          "who'd"             => "who would",
          "what's"            => "what is",
          "what're"           => "what are",
          "what'll"           => "what will",
          "what'd"            => "what would",
          "where's"           => "where is",
          "where'll"          => "where will",
          "where'd"           => "where would",
          "when's"            => "when is",
          "when'll"           => "when will",
          "when'd"            => "when would",
          "why's"             => "why is",
          "why'll"            => "why will",
          "why'd"             => "why would",
          "how's"             => "how is",
          "how'll"            => "how will",
          "how'd"             => "how would",
          "she'd've"          => "she would have",
          "'tisn't"           => "it is not",
          "isn't"             => "is not",
          "aren't"            => "are not",
          "wasn't"            => "was not",
          "weren't"           => "were not",
          "haven't"           => "have not",
          "hasn't"            => "has not",
          "hadn't"            => "had not",
          "won't"             => "will not",
          "wouldn't"          => "would not",
          "don't"             => "do not",
          "doesn't"           => "does not",
          "didn't"            => "did not",
          "can't"             => "cannot",
          "couldn't"          => "could not",
          "shouldn't"         => "should not",
          "mightn't"          => "might not",
          "mustn't"           => "must not",
          "would've"          => "would have",
          "should've"         => "should have",
          "could've"          => "could have",
          "might've"          => "might have",
          "must've"           => "must have",
          "o'"                => "of",
          "o'clock"           => "of the clock",
          "ma'am"             => "madam",
          "ne'er-do-well"     => "never-do-well",
          "cat-o'-nine-tails" => "cat-of-nine-tails",
          "jack-o'-lantern"   => "jack-of-the-lantern",
          "will-o'-the-wisp"  => "will-of-the-wisp",
          "'twas"             => "it was",
        }

        def self.contractions
          CONTRACTIONS
        end

        def self.abbreviations
          ABBREVIATIONS
        end

        def self.stop_words
          STOP_WORDS
        end

        # Single quotes handling
        ALNUM_QUOTE     = /(\w|\D)'(?!')(?=\W|$)/
        QUOTE_WORD      = /(\W|^)'(?=\w)/
        QUOTE_NOT_TWAS1 = /(\W|^)'(?!twas)/i
        QUOTE_NOT_TWAS2 = /(\W|^)‘(?!twas)/i

        def self.handle_single_quotes(text)
          # special treatment for "'twas"
          text = text.gsub(QUOTE_NOT_TWAS1, "\\1 " + Common::PUNCTUATION_MAP["'"] + " ")
          text = text.gsub(QUOTE_NOT_TWAS2, "\\1 " + Common::PUNCTUATION_MAP["‘"] + " ")

          text = text.gsub(QUOTE_WORD, " " + Common::PUNCTUATION_MAP["'"])
          text = text.gsub(ALNUM_QUOTE, "\\1 " + Common::PUNCTUATION_MAP["'"] + " ")
          text
        end
      end
    end
  end
end
