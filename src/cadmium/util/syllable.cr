module Cadmium
  module Util
    # The module `Cadmium::Util::Syllable` contains a single class method,
    # +syllable+, which will use the most accurate technique available to
    # determine the number syllables in a string containing a word passed to it.
    module Syllable
      def self.syllables(word)
        Guess.syllables word
      end

      # Uses English word patterns to guess the number of syllables. A single
      # module method is made available, +syllables+, which, when passed an
      # English word, will return the number of syllables it estimates are in
      # the word.
      #
      # English orthography (the representation of spoken sounds as written
      # signs) is not regular. The same spoken sound can be represented in
      # multiple different ways in written English (e.g. rough/cuff), and the
      # same written letters can be pronounced in different ways in different
      # words (e.g. rough/bough).
      #
      # As the same series of letters can be pronounced in different ways, it is
      # not possible to write an algorithm which can always guess the number of
      # syllables in an english word correctly. However, it is possible to use
      # frequently recurring patterns in english (such as "a final -e is usually
      # silent") to guess with a level of accuracy that is acceptable for
      # applications like syllable counting for readability scoring. This module
      # implements such an algorithm.
      #
      # This module is inspired by the Perl Lingua::EN::Syllable module.
      # However, it uses a different (though not larger) set of patterns to
      # compensate for the 'special cases' which arise out of English's
      # irregular orthography. A number of extra patterns (particularly for
      # derived word forms) means that this module is somewhat more accurate
      # than the Perl original. It also omits a number of patterns found in the
      # original which seem to me to apply to such a small number of cases, or
      # to be of dubious value. Testing the guesses against the Carnegie Mellon
      # Pronouncing Dictionary, this module guesses right around 90% of the
      # time, as against about 85% of the time for the Perl module. However, the
      # dictionary contains a large number of foreign loan words and proper
      # names, and so when the algorithm is tested against 'real world' english,
      # its accuracy is a good deal better. Testing against a range of samples,
      # it guesses right about 95-97% of the time.
      module Guess
        # special cases - 1 syllable less than expected
        SubSyl = [
          /[^aeiou]e$/, # give, love, bone, done, ride ...
          /[aeiou](?:([cfghklmnprsvwz])\1?|ck|sh|[rt]ch)e[ds]$/,
          # (passive) past participles and 3rd person sing present verbs:
          # bared, liked, called, tricked, bashed, matched

          /.e(?:ly|less(?:ly)?|ness?|ful(?:ly)?|ments?)$/,
          # nominal, adjectival and adverbial derivatives from -e$ roots:
          # absolutely, nicely, likeness, basement, hopeless
          # hopeful, tastefully, wasteful

          /ion/,        # action, diction, fiction
          /[ct]ia[nl]/, # special(ly), initial, physician, christian
          /[^cx]iou/,   # illustrious, NOT spacious, gracious, anxious, noxious
          /sia$/,       # amnesia, polynesia
          /.gue$/,      # dialogue, intrigue, colleague
        ]

        # special cases - 1 syllable more than expected
        AddSyl = [
          /i[aiou]/,                       # alias, science, phobia
          /[dls]ien/,                      # salient, gradient, transient
          /[aeiouym]ble$/,                 # -Vble, plus -mble
          /[aeiou]{3}/,                    # agreeable
          /^mc/,                           # mcwhatever
          /ism$/,                          # sexism, racism
          /(?:([^aeiouy])\1|ck|mp|ng)le$/, # bubble, cattle, cackle, sample, angle
          /dnt$/,                          # couldn/t
          /[aeiou]y[aeiou]/,               # annoying, layer
        ]

        # special cases not actually used - these seem to me to be either very
        # marginal or actually break more stuff than they fix
        NotUsed = [
          /^coa[dglx]./,     # +1 coagulate, coaxial, coalition, coalesce - marginal
          /[^gq]ua[^auieo]/, # +1 'du-al' - only for some speakers, and breaks
          /riet/,            # variety, parietal, notoriety - marginal?
        ]

        def self.syllables(word)
          return 1 if word.size == 1
          word = word.downcase.delete("'")

          syllables = word.scan(/[aeiouy]+/).size

          # special cases
          SubSyl.each do |pat|
            syllables -= 1 if pat.match(word)
          end

          AddSyl.each do |pat|
            syllables += 1 if pat.match(word)
          end

          syllables = 1 if syllables < 1 # no vowels?
          syllables
        end
      end
    end
  end
end
