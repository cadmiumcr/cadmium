module Cadmium
  module WordNet
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
    ADJECTIVE_POINTERS = {
      ";r" => "Domain of synset - REGION",
      "!"  => "Antonym",
      "\\" => "Pertainym (pertains to noun)",
      "<"  => "Participle of verb",
      "&"  => "Similar to",
      "="  => "Attribute",
      ";c" => "Domain of synset - TOPIC",
    }
    ADVERB_POINTERS = {
      ";r" => "Domain of synset - REGION",
      "!"  => "Antonym",
      ";u" => "Domain of synset - USAGE",
      "\\" => "Derived from adjective",
      ";c" => "Domain of synset - TOPIC",
    }

    MEMBER_OF_THIS_DOMAIN_TOPIC  = "-c"
    DERIVATIONALLY_RELATED_FORM  = "+"
    PART_MERONYM                 = "%p"
    INSTANCE_HYPONYM             = "~i"
    HYPERNYM                     = "@"
    DOMAIN_OF_SYNSET_REGION      = ";r"
    ANTONYM                      = "!"
    PART_HOLONYM                 = "#p"
    SUBSTANCE_MERONYM            = "%s"
    VERB_GROUP                   = "$"
    DOMAIN_OF_SYNSET_USAGE       = ";u"
    MEMBER_OF_THIS_DOMAIN_REGION = "-r"
    SUBSTANCE_HOLONYM            = "#s"
    DERIVED_FROM_ADJECTIVE       = "\\"
    PARTICIPLE_OF_VERB           = "<"
    SIMILAR_TO                   = "&"
    ATTRIBUTE                    = "="
    ALSO_SEE                     = "^"
    CAUSE                        = ">"
    MEMBER_OF_THIS_DOMAIN_USAGE  = "-u"
    DOMAIN_OF_SYNSET_TOPIC       = ";c"
    MEMBER_MERONYM               = "%m"
    HYPONYM                      = "~"
    INSTANCE_HYPERNYM            = "@i"
    ENTAILMENT                   = "*"
    MEMBER_HOLONYM               = "#m"
  end
end
