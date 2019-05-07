require "./inflector/*"

module Cadmium
  module Inflector
    module StringExtension
      @@_noun_inflector = Cadmium::Inflector::NounInflector.new
      @@_verb_inflector = Cadmium::Inflector::PresentVerbInflector.new

      def pluralize(noun = true)
        if noun
          @@_noun_inflector.pluralize(self)
        else
          @@_verb_inflector.pluralize(self)
        end
      end

      def singularize(noun = true)
        if noun
          @@_noun_inflector.singularize(self)
        else
          @@_verb_inflector.singularize(self)
        end
      end
    end

    module IntExtension
      def to_nth
        Cadmium::Inflectors::CountInflector.nth(self)
      end
    end
  end
end
