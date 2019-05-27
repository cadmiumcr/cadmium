require "./base"
require "./common"

module Cadmium
  module Tokenizer
    class Pragmatic
      module Languages
        class English < Languages::Base
          ABBREVIATIONS = Set.new(%w[adj adm adv al ala alta apr arc ariz ark art assn asst attys aug ave bart bld bldg blvd brig bros btw cal calif capt cl cmdr co col colo comdr con conn corp cpl cres ct d.phil dak dec del dept det dist dr dr.phil dr.philos drs e.g ens esp esq etc exp expy ext feb fed fla ft fwy fy ga gen gov hon hosp hr hway hwy i.e i.b.m ia id ida ill inc ind ing insp jan jr jul jun kan kans ken ky la lt ltd maj man mar mass may md me med messrs mex mfg mich min minn miss mlle mm mme mo mont mr mrs ms msgr mssrs mt mtn neb nebr nev no nos nov nr oct ok okla ont op ord ore p pa pd pde penn penna pfc ph ph.d pl plz pp prof pvt que rd ref rep reps res rev rt sask sec sen sens sep sept sfc sgt sr st supt surg tce tenn tex u.s u.s.a univ usafa ut v va ver vs vt wash wis wisc wy wyo yuk])
          STOP_WORDS    = Set.new(%w[i.e. e.g. &#;f 'll 've +// -/+ </li> </p> </td> <br <br/> <br/><br/> <li> <p> <sup></sup> <sup></sup></li> <td <td> a a's able about above abroad abst accordance according accordingly across act actually added adj adopted affected affecting affects after afterwards again against ago ah ahead ain't all allow allows almost alone along alongside already also although always am amid amidst among amongst amoungst amount an and announce another any anybody anyhow anymore anyone anything anyway anyways anywhere apart apparently appear appreciate appropriate approximately are aren aren't arent arise around as aside ask asking associated at auth available away awfully b back backward backwards be became because become becomes becoming been before beforehand begin beginning beginnings begins behind being believe below beside besides best better between beyond bill biol both bottom brief briefly but by c c'mon c's ca call came can can't cannot cant caption cause causes certain certainly changes class= clearly co co. com come comes computer con concerning consequently consider considering contain containing contains corresponding could couldn't couldnt course cry currently d dare daren't date de definitely describe described despite detail did didn't different directly do does doesn't doing don't done down downwards due during e each ed edu effect eg eight eighty either eleven else elsewhere empty end ending enough entirely especially et et-al etc even ever evermore every everybody everyone everything everywhere ex exactly example except f fairly far farther few fewer ff fifteen fifth fify fill find fire first five fix followed following follows for forever former formerly forth forty forward found four from front full further furthermore g gave get gets getting give given gives giving go goes going gone got gotten greetings h had hadn't half happens hardly has hasn't hasnt have haven't having he he'd he'll he's hed hello help hence her here here's hereafter hereby herein heres hereupon hers herself hes hi hid him himself his hither home hopefully how how's howbeit however http https hundred i i'd i'll i'm i've id ie if ignored im immediate immediately importance important in inasmuch inc inc. indeed index indicate indicated indicates information ing inner inside insofar instead interest into invention inward is isn't it it'd it'll it's itd its itself j just k keep keeps kept keys kg km know known knows l largely last lately later latter latterly least less lest let let's lets like liked likely likewise line little look looking looks low lower ltd m made mainly make makes many may maybe mayn't me mean means meantime meanwhile merely mg might mightn't mill million mine minus miss ml more moreover most mostly move mr mrs much mug must mustn't my myself n na name namely nay nd near nearly necessarily necessary need needn't needs neither never neverf neverless nevertheless new next nine ninety no no-one nobody non none nonetheless noone nor normally nos not noted nothing notwithstanding novel now nowhere o obtain obtained obviously of off often oh ok okay old omitted on once one one's ones only onto opposite or ord other others otherwise ought oughtn't our ours ours ourselves out outside over overall owing own p page pages part particular particularly past per perhaps placed please plus poorly possible possibly potentially pp predominantly present presumably previously primarily probably promptly proud provided provides put q que quickly quite qv r ran rather rd re readily really reasonably recent recently ref refs regarding regardless regards related relatively research respectively resulted resulting results right round run s said same saw say saying says sec second secondly section see seeing seem seemed seeming seems seen self selves sensible sent serious seriously seven several shall shan't she she'd she'll she's shed shes should shouldn't show showed shown showns shows side significant significantly similar similarly since sincere six sixty slightly so some somebody someday somehow someone somethan something sometime sometimes somewhat somewhere soon sorry specifically specified specify specifying state states still stop strongly sub substantially successfully such sufficiently suggest sup sure system t t's take taken taking tell ten tends th than thank thanks thanx that that'll that's that've thats the their theirs them themselves then thence there there'd there'll there're there's there've thereafter thereby thered therefore therein thereof therere theres thereto thereupon these they they'd they'll they're they've theyd theyre thick thin thing things think third thirty this thorough thoroughly those thou though thoughh thousand three throug through throughout thru thus til till tip to together too took top toward towards tried tries truly try trying ts twelve twenty twice two u un under underneath undoing unfortunately unless unlike unlikely until unto up upon ups upwards us use used useful usefully usefulness uses using usually uucp v value various versus very via viz vol vols vs w want wants was wasn't way we we'd we'll we're we've wed welcome well went were weren't what what'll what's what're what've whatever whats when when's whence whenever where where's whereafter whereas whereby wherein wheres whereupon wherever whether which whichever while whilst whim whither who who'd who'll who's whod whoever whole whom whomever whos whose why why's widely will willing wish with within without won't wonder word words world would wouldn't www x y yes yet you you'd you'll you're you've youd your youre yours yourself yourselves z zero])
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
end
