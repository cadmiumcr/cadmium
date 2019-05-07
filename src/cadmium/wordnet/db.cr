module Cadmium
  module WordNet
    # Represents the WordNet database, and provides some basic interaction.
    class DB
      # By default, use the bundled WordNet
      @@path = File.expand_path("../../../data/wordnet/", __DIR__)

      @@raw_wordnet = {} of String => String

      # To use your own WordNet installation (rather than the one bundled with rwordnet:
      # Returns the path to the WordNet installation currently in use. Defaults to the bundled version of WordNet.
      class_property path : String

      # Open a wordnet database. You shouldn't have to call this directly; it's
      # handled by the autocaching implemented in lemma.rb.
      #
      # `path` should be a string containing the absolute path to the root of a
      # WordNet installation.
      def self.open(path, &block)
        File.open(File.join(@@path, path), "r") do |f|
          yield f
        end
      end

      def self.open(path)
        File.open(File.join(@@path, path), "r")
      end
    end
  end
end
