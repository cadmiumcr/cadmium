module Cadmium
  module Util
    class EdgeWeightedDigraph
      @num_edges : Int32

      @adj : Array(Bag(DirectedEdge))

      def initialize
        @num_edges = 0
        @adj = [] of Bag(DirectedEdge)
      end

      def v
        @adj.size
      end

      def e
        @num_edges
      end

      def add(from : Int32, to : Int32, weight : Float64)
        e = DirectedEdge.new(from, to, weight)
        add_edge(e)
      end

      def add_edge(e : DirectedEdge)
        if !@adj[e.from]?
          filler = Array.new(e.from - (@adj.size - 1), Bag(DirectedEdge).new)
          @adj.concat(filler)
        end

        @adj[e.from].add(e)
        @num_edges += 1
      end

      def get_adj(v : Int32)
        return [] of Bag if !@adj[v]
        @adj[v].unpack
      end

      def edges
        list = Bag(DirectedEdge).new
        @adj.each do |i|
          i.unpack.each do |item|
            list.add(item)
          end
        end
        list.unpack
      end

      def to_s
        result = [] of String
        edges.each do |edge|
          result.push(edge.to_s)
        end
        result.join("\n")
      end

      struct DirectedEdge
        getter from : Int32

        getter to : Int32

        getter weight : Float64

        def initialize(@from : Int32, @to : Int32, @weight : Float64)
        end

        def to_s
          sprintf("%s -> %s, %s", @from, @to, @weight)
        end
      end
    end
  end
end
