require "./tense_inflector"
require "./form_set"

module Cadmium
  # Allows you to pluralize or singularize nouns.
  class NounInflector < TenseInflector
    def initialize
      @ambiguous = [
        "bison", "bream", "carp", "chassis", "cod", "corps", "debris", "deer",
        "diabetes", "equipment", "elk", "fish", "flounder", "gallows", "graffiti",
        "headquarters", "herpes", "highjinks", "homework", "information",
        "mackerel", "mews", "money", "news", "rice", "rabies", "salmon", "series",
        "sheep", "shrimp", "species", "swine", "trout", "tuna", "whiting", "wildebeest",
      ]

      @custom_plural_forms = [] of Tuple(Regex, String)
      @custom_singular_forms = [] of Tuple(Regex, String)
      @singular_forms = FormSet.new
      @plural_forms = FormSet.new

      add_irregular("child", "children")
      add_irregular("man", "men")
      add_irregular("person", "people")
      add_irregular("sex", "sexes")
      add_irregular("mouse", "mice")
      add_irregular("ox", "oxen")
      add_irregular("foot", "feet")
      add_irregular("tooth", "teeth")
      add_irregular("goose", "geese")
      add_irregular("ephemeris", "ephemerides")
      add_irregular("cloth", "clothes")
      add_irregular("hero", "heroes")

      plural_forms.regular_forms.push({/y$/i, "ies"})
      plural_forms.regular_forms.push({/ife$/i, "ives"})
      plural_forms.regular_forms.push({/(antenn|formul|nebul|vertebr|vit)a$/i, "\\1ae"})
      plural_forms.regular_forms.push({/(octop|vir|radi|nucle|fung|cact|stimul)us$/i, "\\1i"})
      plural_forms.regular_forms.push({/(buffal|tomat|tornad)o$/i, "\\1oes"})
      plural_forms.regular_forms.push({/(sis)$/i, "ses"})
      plural_forms.regular_forms.push({/(matr|vert|ind|cort)(ix|ex)$/i, "\\1ices"})
      plural_forms.regular_forms.push({/sses$/i, "sses"})
      plural_forms.regular_forms.push({/(x|ch|ss|sh|s|z)$/i, "\\1es"})
      plural_forms.regular_forms.push({/^(?!talis|.*hu)(.*)man$/i, "\\1men"})
      plural_forms.regular_forms.push({/(.*)/i, "\\1s"})

      singular_forms.regular_forms.push({/([^v])ies$/i, "\\1y"})
      singular_forms.regular_forms.push({/ives$/i, "ife"})
      singular_forms.regular_forms.push({/(antenn|formul|nebul|vertebr|vit)ae$/i, "\\1a"})
      singular_forms.regular_forms.push({/(octop|vir|radi|nucle|fung|cact|stimul)(i)$/i, "\\1us"})
      singular_forms.regular_forms.push({/(buffal|tomat|tornad)(oes)$/i, "\\1o"})
      singular_forms.regular_forms.push({/(analy|naly|synop|parenthe|diagno|the)ses$/i, "\\1sis"})
      singular_forms.regular_forms.push({/(vert|ind|cort)(ices)$/i, "\\1ex"})
      singular_forms.regular_forms.push({/(matr|append)(ices)$/i, "\\1ix"})
      singular_forms.regular_forms.push({/(x|ch|ss|sh|s|z)es$/i, "\\1"})
      singular_forms.regular_forms.push({/men$/i, "man"})
      singular_forms.regular_forms.push({/ss$/i, "ss"})
      singular_forms.regular_forms.push({/s$/i, ""})
    end

    # Gives the plural form of a noun.
    def pluralize(token)
      ize(token, plural_forms, custom_plural_forms)
    end

    # Gives the singular form of a noun.
    def singularize(token)
      ize(token, singular_forms, custom_singular_forms)
    end
  end
end
