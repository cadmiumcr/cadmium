module Cadmium
  module Util
    struct Bag(T)
      @dictionary : Array(T)

      @n_element : Int32

      def initialize
        @dictionary = [] of T
        @n_element = 0
      end

      def add(element : T)
        @dictionary.push(element)
        @n_element += 1
        self
      end

      def empty?
        @n_element > 0
      end

      def contains(item : T)
        @dictionary.includes?(item)
      end

      def unpack
        @dictionary.dup
      end
    end
  end
end
