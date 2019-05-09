module Cadmium
  module WordNet
    # Valid pointer synbols for nouns
    NOUN_POINTERS = {
      "-c" => "Member of this domain - TOPIC",
      "+"  => "Derivationally related form",
      "%p" => "Part meronym",
      "~i" => "Instance Hyponym",
      "@"  => "Hypernym",
      ";r" => "Domain of synset - REGION",
      "!"  => "Antonym",
      "#p" => "Part holonym",
      "%s" => "Substance meronym",
      ";u" => "Domain of synset - USAGE",
      "-r" => "Member of this domain - REGION",
      "#s" => "Substance holonym",
      "="  => "Attribute",
      "-u" => "Member of this domain - USAGE",
      ";c" => "Domain of synset - TOPIC",
      "%m" => "Member meronym",
      "~"  => "Hyponym",
      "@i" => "Instance Hypernym",
      "#m" => "Member holonym",
    }

    # Valid pointer symbols for verbs
    VERB_POINTERS = {
      "+"  => "Derivationally related form",
      "@"  => "Hypernym",
      ";r" => "Domain of synset - REGION",
      "!"  => "Antonym",
      ";u" => "Domain of synset - USAGE",
      "$"  => "Verb Group",
      ";c" => "Domain of synset - TOPIC",
      ">"  => "Cause",
      "~"  => "Hyponym",
      "*"  => "Entailment",
    }

    # Valid pointer symbols for adjectives
    ADJECTIVE_POINTERS = {
      ";r" => "Domain of synset - REGION",
      "!"  => "Antonym",
      "\\" => "Pertainym (pertains to noun)",
      "<"  => "Participle of verb",
      "&"  => "Similar to",
      "="  => "Attribute",
      ";c" => "Domain of synset - TOPIC",
    }

    # Valid pointer symbols for adverbs
    ADVERB_POINTERS = {
      ";r" => "Domain of synset - REGION",
      "!"  => "Antonym",
      ";u" => "Domain of synset - USAGE",
      "\\" => "Derived from adjective",
      ";c" => "Domain of synset - TOPIC",
    }

    # :nodoc:
    MEMBER_OF_THIS_DOMAIN_TOPIC = "-c"
    # :nodoc:
    DERIVATIONALLY_RELATED_FORM = "+"
    # :nodoc:
    PART_MERONYM = "%p"
    # :nodoc:
    INSTANCE_HYPONYM = "~i"
    # :nodoc:
    HYPERNYM = "@"
    # :nodoc:
    DOMAIN_OF_SYNSET_REGION = ";r"
    # :nodoc:
    ANTONYM = "!"
    # :nodoc:
    PART_HOLONYM = "#p"
    # :nodoc:
    SUBSTANCE_MERONYM = "%s"
    # :nodoc:
    VERB_GROUP = "$"
    # :nodoc:
    DOMAIN_OF_SYNSET_USAGE = ";u"
    # :nodoc:
    MEMBER_OF_THIS_DOMAIN_REGION = "-r"
    # :nodoc:
    SUBSTANCE_HOLONYM = "#s"
    # :nodoc:
    DERIVED_FROM_ADJECTIVE = "\\"
    # :nodoc:
    PARTICIPLE_OF_VERB = "<"
    # :nodoc:
    SIMILAR_TO = "&"
    # :nodoc:
    ATTRIBUTE = "="
    # :nodoc:
    ALSO_SEE = "^"
    # :nodoc:
    CAUSE = ">"
    # :nodoc:
    MEMBER_OF_THIS_DOMAIN_USAGE = "-u"
    # :nodoc:
    DOMAIN_OF_SYNSET_TOPIC = ";c"
    # :nodoc:
    MEMBER_MERONYM = "%m"
    # :nodoc:
    HYPONYM = "~"
    # :nodoc:
    INSTANCE_HYPERNYM = "@i"
    # :nodoc:
    ENTAILMENT = "*"
    # :nodoc:
    MEMBER_HOLONYM = "#m"
  end
end
