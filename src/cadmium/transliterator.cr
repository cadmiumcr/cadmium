require "./transliterator/*"

module Cadmium
  module Transliterator
    include Cadmium::Transliterator::CharMap

    extend self

    @@char_map = {} of Int32 => Array(String) | Array(String | Nil)

    DEFAULT_OPTS = {
      unknown:       "[?]",
      replace:       {} of String | Regex => String,
      replace_after: {} of String | Regex => String,
      ignore:        [] of String | Char,
      trim:          true,
    }

    def transliterate(source, **options)
      opts = DEFAULT_OPTS.merge(options)
      str = source.dup

      # Run with ignored characters
      if opts[:ignore].size > 0
      end

      str = replace_str(str, opts[:replace])
      str = fix_chinese_space(str)
      str_arr = ucs2decode(str)
      str_arr_new = [] of String

      str_arr.each do |ord|
        if ord > 0xffff
          str_arr_new.push opts[:unknown]
        else
          offset = ord >> 8

          unless @@char_map[offset]?
            @@char_map[offset] = CHAR_MAP[offset]? || [] of String
          end

          ord &= 0xff
          text = @@char_map[offset][ord]?

          if text.nil?
            str_arr_new.push(opts[:unknown])
          else
            str_arr_new.push(@@char_map[offset][ord].not_nil!)
          end
        end
      end

      # trim spaces at the beginning and ending of the string
      if opts[:trim] && str_arr_new.size > 1
        opts[:replace_after][/(^ +?)|( +?$)/] = ""
      end
      str_new = str_arr_new.join("")

      str_new = replace_str(str_new, opts[:replace_after])
      str_new
    end

    def replace_str(source, replace)
      str = source.dup
      replace.each do |(item, replacement)|
        str = str.gsub(item, replacement)
      end
      str
    end

    private def fix_chinese_space(str)
      str.gsub(Regex.new("([^\u4e00-\u9fa5\W])([\u4e00-\u9fa5])"), "\\1 \\2")
    end

    private def ucs2decode(str)
      str = str.codepoints
      output = [] of Int32
      counter = 0
      while counter < str.size
        value = str[counter]
        counter += 1
        if value && value >= 0xD800 && value <= 0xDBFF && counter < str.size
          # high surrogate, and there is a next character
          extra = str[counter += 1]
          if extra && (extra & 0xFC00) == 0xDC00 # low surrogate
            output.push(((value & 0x3FF) << 10) + (extra & 0x3FF) + 0x10000)
          else
            # unmatched surrogate; only append this code unit, in case the next
            # code unit is the high surrogate of a surrogate pair
            output.push(value)
            counter -= 1
          end
        else
          output.push(value)
        end
      end
      output
    end

    private def escape_regex(str)
      # str.gsub(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/, "\\0")
      str
    end

    module StringExtension
      def transliterate(**options)
        Cadmium::Transliterator.transliterate(self, **options)
      end
    end
  end
end
