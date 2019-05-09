module Cadmium
  module Util
    # Represents a digraph, you can add an edge, get the number
    # vertexes, edges, get all edges and use
    # `#to_s` to print the Digraph.
    class EdgeWeightedDigraph
      @num_edges : Int32

      @adj : Array(Bag(DirectedEdge))

      # Create a new `EdgeWeightedDigraph`.
      def initialize
        @num_edges = 0
        @adj = [] of Bag(DirectedEdge)
      end

      # Get the number of vertexs saved.
      def v
        @adj.size
      end

      # Get the number of edges saved.
      def e
        @num_edges
      end

      # Create and add a new `DirectedEdge`.
      def add(from : Int32, to : Int32, weight : Float64)
        e = DirectedEdge.new(from, to, weight)
        add_edge(e)
      end

      # Add a `DirectedEdge`.
      def add_edge(e : DirectedEdge)
        if !@adj[e.from]?
          filler = Array.new(e.from - (@adj.size - 1), Bag(DirectedEdge).new)
          @adj.concat(filler)
        end

        @adj[e.from].add(e)
        @num_edges += 1
      end

      # Use callback on all edges from v.
      def get_adj(v : Int32)
        return [] of Bag if !@adj[v]
        @adj[v].unpack
      end

      # Use callback on all edges.
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
