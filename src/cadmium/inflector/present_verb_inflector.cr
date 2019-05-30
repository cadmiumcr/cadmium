require "./tense_inflector"
require "./form_set"

module Cadmium
  #
  class PresentVerbInflector < TenseInflector
    def initialize
      @ambiguous = [
        "will",
      ]

      @custom_plural_forms = [] of Tuple(Regex, String)
      @custom_singular_forms = [] of Tuple(Regex, String)
      @singular_forms = FormSet.new
      @plural_forms = FormSet.new

      add_irregular("am", "are")
      add_irregular("is", "are")
      add_irregular("was", "were")
      add_irregular("has", "have")

      singular_forms.regular_forms.push({/ed$/i, "ed"})
      singular_forms.regular_forms.push({/ss$/i, "sses"})
      singular_forms.regular_forms.push({/x$/i, "xes"})
      singular_forms.regular_forms.push({/(h|z|o)$/i, "\\1es"})
      singular_forms.regular_forms.push({/$zz/i, "zzes"})
      singular_forms.regular_forms.push({/([^a|e|i|o|u])y$/i, "\\1ies"})
      singular_forms.regular_forms.push({/$/i, "s"})

      plural_forms.regular_forms.push({/sses$/i, "ss"})
      plural_forms.regular_forms.push({/xes$/i, "x"})
      plural_forms.regular_forms.push({/([cs])hes$/i, "\\1h"})
      plural_forms.regular_forms.push({/zzes$/i, "zz"})
      plural_forms.regular_forms.push({/([^h|z|o|i])es$/i, "\\1e"})
      plural_forms.regular_forms.push({/ies$/i, "y"}) # flies->fly
      plural_forms.regular_forms.push({/e?s$/i, ""})
    end
  end
end
