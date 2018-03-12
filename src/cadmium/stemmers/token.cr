module Cadmium
  module Stemmers
    class Token
      @string : String
      @original : String
      @vowels : Array(String)
      @regions : Hash(String, Int32)

      property :string
      getter :orgiginal, :vowels, :regions

      forward_missing_to @string

      def initialize(string : String)
        @string = string
        @original = string
        @regions = {} of String => Int32
        @vowels = [] of String
      end

      def using_vowels(vowels)
        @vowels = vowels
        self
      end

      def mark_region(region, &block)
        @regions[region] = yield
        self
      end

      def mark_region(region, index)
        @regions[region] = index
        self
      end

      def replace_all(find, replace)
        @string = string.split(find).join(replace)
        self
      end

      def replace_suffix_in_region(suffix, replace, region)
        suffixes = suffix.is_a?(Array) ? suffix : [suffix]
        (0..suffixes.size).each do |i|
          if has_suffix_in_region(suffixes[i], region)
            @string = @string[0, -suffixes[i].size] + replace
            return self
          end
        end
        self
      end

      def has_vowel_at_index(index)
        !!@vowels[index]?
      end

      def next_vowel_index(start = 0)
        index = (start >= 0 && start < @string.size) ? start : @string.size
        while index < string.size && !has_vowel_at_index(index)
          index += 1
        end
        index
      end

      def next_consonant_index(start = 0)
        index = (start >= 0 && start < @string.size) ? start : @string.size
        while index < string.size && has_vowel_at_index(index)
          index += 1
        end
        index
      end

      def has_suffix(suffix)
        @string[-suffix.size..-1] == suffix
      end

      def has_suffix_in_region(suffix, region)
        region_start = @regions[region]? || 0
        suffix_start = @string.size - @suffix.size
        has_suffix(suffix) && suffix_start >= region_start
      end
    end
  end
end
