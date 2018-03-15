module Cadmium
  class Phonetics
    class SoundEx < Phonetics
      def self.process(token, max_length = nil)
        token = token.downcase
        transformed = condense(transform(token[1..-1]))
        # deal with duplicate INITIAL consonant SOUNDS
        transformed = transformed.sub(Regex.new("^#{transformed[0]}"), "")
        token[0].upcase + pad_right_0(transformed.gsub(/\D/, ""))[0, (max_length && max_length - 1) || 3]
      end

      def self.transform_lips(token)
        token.gsub(/[bfpv]/, "1")
      end

      def self.transform_throats(token)
        token.gsub(/[cgjkqsxz]/, "2")
      end

      def self.transform_tongue(token)
        token.gsub(/[dt]/, "3")
      end

      def self.transform_l(token)
        token.gsub(/[l]/, "4")
      end

      def self.transform_hum(token)
        token.gsub(/[mn]/, "5")
      end

      def self.transform_r(token)
        token.gsub(/r/, "6")
      end

      def self.condense(token)
        token.gsub(/(\d)?\1+/, "\\1")
      end

      def self.pad_right_0(token)
        if token.size < 4
          token + "0" * (3 - token.size)
        else
          token
        end
      end

      def self.transform(token)
        transform_lips(
          transform_throats(
            transform_tongue(
              transform_l(
                transform_hum(
                  transform_r(token))))))
      end
    end
  end
end
