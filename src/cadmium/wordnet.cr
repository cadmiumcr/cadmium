require "./wordnet/pointer"
require "./wordnet/db"
require "./wordnet/lemma"
require "./wordnet/pointers"
require "./wordnet/synset"

module Cadmium
  # API to grant full access to the Stanford WordNet project allowing
  # you to find words, definitions (gloss), hypernyms, hyponyms,
  # antonyms, etc.
  module WordNet
    # Find a lemma for a given word and pos. Valid parts of speech are:
    # :adj, :adv, :noun, :verb. Additionally, you can use the shorthand
    # forms of each of these (:a, :r, :n, :v)
    def self.lookup(word : String, pos : Symbol | String)
      Lemma.find(word, pos)
    end

    # Find all lemmas for this word across all known parts of speech
    def self.lookup(word : String)
      Lemma.find_all(word)
    end

    # Create a `Synset` by *offset* and *pos*
    def self.get(offset : Int32, pos : Symbol | String)
      Synset.new(pos, offset)
    end

    # Get the root of a *form*
    def self.morphy(form : String)
      Synset.morphy(form)
    end

    # Get the root of a *form* with a specific *pos*
    def self.morphy(form : String, pos : String | Symbol)
      Synset.morphy(form, pos)
    end
  end
end
