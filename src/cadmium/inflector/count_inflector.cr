module Cadmium
  # Inflects a number by adding a suffix onto the end
  # of it.
  #
  # ```
  # 100.to_nth
  # # => "100th"
  #
  # 73.to_nth
  # # => "73rd"
  #
  # 1221.to_nth
  # "1221st"
  # ```
  module CountInflector
    extend self

    # Returns a number in it's "nth" form
    def nth(i)
      i.to_s + nth_form(i)
    end

    private def nth_form(i)
      teenth = i % 100

      if teenth > 10 && teenth < 14
        "th"
      else
        case i % 10
        when 1
          "st"
        when 2
          "nd"
        when 3
          "rd"
        else
          "th"
        end
      end
    end
  end
end
