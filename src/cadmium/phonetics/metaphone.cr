require "./phonetics"

module Cadmium
  class Metaphone < Phonetics
    def self.process(token, max_length = nil)
      max_length ||= 32
      token = token.downcase
      token = dedup(token)
      token = drop_initial_letters(token)
      token = drop_b_after_m_at_end(token)
      token = transform_ck(token)
      token = c_transform(token)
      token = d_transform(token)
      token = drop_g(token)
      token = transform_g(token)
      token = drop_h(token)
      token = transform_ph(token)
      token = transform_q(token)
      token = transform_s(token)
      token = transform_x(token)
      token = transform_t(token)
      token = drop_t(token)
      token = transform_v(token)
      token = transform_wh(token)
      token = drop_w(token)
      token = drop_y(token)
      token = transform_z(token)
      token = drop_vowels(token)

      token = token.upcase
      if max_length && token.size > max_length
        token = token[0, max_length]
      end

      token
    end

    def self.dedup(token)
      token.gsub(/([^c])\1/, "\\1")
    end

    def self.drop_initial_letters(token)
      if token.match(/^(kn|gn|pn|ae|wr)/)
        return token[1..-1]
      end
      token
    end

    def self.drop_b_after_m_at_end(token)
      token.sub(/mb$/, "m")
    end

    def self.c_transform(token)
      token = token.gsub(/([^s]|^)(c)(h)/, "\\1x\\3").strip

      token = token.gsub(/cia/, "xia")
      token = token.gsub(/c(i|e|y)/, "s\\1")
      token = token.gsub(/c/, "k")

      token
    end

    def self.d_transform(token)
      token = token.gsub(/d(ge|gy|gi)/, "j\\1")
      token = token.gsub(/d/, "t")
      token
    end

    def self.drop_g(token)
      token = token.gsub(/gh(^$|[^aeiou])/, "h\\1")
      token = token.gsub(/g(n|ned)$/, "\\1")
      token
    end

    def self.transform_g(token)
      token = token.gsub(/gh/, "f")
      token = token.gsub(/([^g]|^)(g)(i|e|y)/, "\\1j\\3")
      token = token.gsub(/gg/, "g")
      token = token.gsub(/g/, "k")
      token
    end

    def self.drop_h(token)
      token.gsub(/([aeiou])h([^aeiou]|$)/, "\\1\\2")
    end

    def self.transform_ck(token)
      token.gsub(/ck/, "k")
    end

    def self.transform_ph(token)
      token.gsub(/ph/, "f")
    end

    def self.transform_q(token)
      token.gsub(/q/, "k")
    end

    def self.transform_s(token)
      token.gsub(/s(h|io|ia)/, "x\\1")
    end

    def self.transform_t(token)
      token = token.gsub(/t(ia|io)/, "x\\1")
      token = token.gsub(/th/, "0")
      token
    end

    def self.drop_t(token)
      token.gsub(/tch/, "ch")
    end

    def self.transform_v(token)
      token.gsub(/v/, "f")
    end

    def self.transform_wh(token)
      token.gsub(/^wh/, "w")
    end

    def self.drop_w(token)
      token.gsub(/w([^aeiou]|$)/, "\\1")
    end

    def self.transform_x(token)
      token = token.gsub(/^x/, "s")
      token = token.gsub(/x/, "ks")
      token
    end

    def self.drop_y(token)
      token.gsub(/y([^aeiou]|$)/, "\\1")
    end

    def self.transform_z(token)
      token.gsub(/z/, "s")
    end

    def self.drop_vowels(token)
      token[0] + token[1..-1].gsub(/[aeiou]/, "")
    end
  end
end
