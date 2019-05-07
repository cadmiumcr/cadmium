module Cadmium
  module Util
    module Paragraph
      # Splits text into an array of paragraphs.
      def self.paragraphs(text)
        text.strip.split(/(?:\n[\r\t ]*)+/).map { |p| p.strip }
      end
    end
  end
end
