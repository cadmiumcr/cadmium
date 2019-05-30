module Cadmium
  module CountInflector
    extend self

    def nth(i)
      i.to_s + nth_form(i)
    end

    private def nth_form(i)
      teenth = i % 100

      if teenth > 10 && teenth < 14
        return "th"
      else
        case i % 10
        when 1
          return "st"
        when 2
          return "nd"
        when 3
          return "rd"
        else
          return "th"
        end
      end
    end
  end
end
