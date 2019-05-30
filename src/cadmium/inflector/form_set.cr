module Cadmium
  abstract class TenseInflector
    class FormSet
      property regular_forms : Array(Tuple(Regex, String))
      property irregular_forms : Hash(String, String)

      def initialize
        @regular_forms = [] of Tuple(Regex, String)
        @irregular_forms = {} of String => String
      end
    end
  end
end
