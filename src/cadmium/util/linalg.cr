module Cadmium
  # :nodoc:
  module Linalg
    extend self

    module Vector
      extend self

      # Add vector's `v1` and `v2`.
      def add(v1, v2)
        [v1[0] + v2[0], v1[1] + v2[1]]
      end

      # Subtract vector `v1` from `v2`.
      def sub(v1, v2)
        [v1[0] - v2[0], v1[1] - v2[1]]
      end

      # Multiply vector's `v1` and `v2`.
      def mult(v1, v2)
        [v1[0] * v2[0], v1[1] * v2[1]]
      end

      # Divide vector `v1` by `v2`.
      def div(v1, v2)
        [v1[0] / v2[0], v1[1] / v2[1]]
      end

      # Find the euclidian distance between any number of
      # n-dimensional vectors.
      def distance(*points)
        squares = points.map { |a, b| (a.to_f64 - b.to_f64) ** 2.0 }
        Math.sqrt squares.sum
      end

      # Get the average of an array of vectors.
      def mean(*points)
        sumv = [0_f64] * points.max.size
        points.each do |item|
          item.each_with_index do |num, i|
            sumv[i] += num
          end
        end

        mean = [0_f64] * sumv.size
        sumv.each_with_index do |num, i|
          mean[i] = num / points.size
        end

        mean
      end
    end
  end
end
