module Cadmium
  module WordNet
    # Pointers represent the relations between the words in one synset and another.
    class Pointer
      # The symbol that devices the relationship this pointer represents, e.g. "!" for verb antonym. Valid
      # pointer symbols are defined in pointers.cr
      getter symbol : String

      # The offset, in bytes, of this pointer in WordNet's internal database.
      getter offset : Int32

      # The part of speech this pointer represents. One of 'n', 'v', 'a' (adjective), or 'r' (adverb).
      getter pos : String

      # The synset from which this pointer...points.
      getter source : String

      # The synset to which this pointer...points.
      getter target : String

      # Create a pointer. Pointers represent the relations between the words in one synset and another,
      # and are referenced by a shorthand symbol (e.g. '!' for verb antonym). The list
      # of valid pointer symbols is defined in pointers.cr
      def initialize(@symbol : String, @offset : Int32, @pos : String, @source : String)
        @target = @source[2, 2]
      end

      def is_semantic?
        @source == "00" && @target == "00"
      end
    end
  end
end
