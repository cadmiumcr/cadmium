require "./wordnet/pointer"
require "./wordnet/db"
require "./wordnet/lemma"
require "./wordnet/pointers"
require "./wordnet/synset"

module Cadmium
  module WordNet
    def self.lookup(word : String, pos : Symbol | String)
      lemma = Lemma.find(word, pos)
      return lemma ? lemma.synsets : [] of Synset
    end

    def self.lookup(word : String)
      lemmas = Lemma.find_all(word)
      return lemmas.map { |lemma| lemma.synsets.flatten }.flatten
    end

    def self.get(offset : Int32, pos : Symbol | String)
      return Synset.new(pos, offset)
    end

    def self.morphy(form)
      Synset.morphy(form)
    end

    def self.morphy(form, pos)
      Synset.morphy(form, pos)
    end
  end
end
