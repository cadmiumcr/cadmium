require "./tokenizer/*"

module Cadmium
  module NGrams
    extend self

    @@tokenizer = Cadmium::Tokenizer::WordTokenizer.new

    def tokenizer=(tokenizer : Cadmium::Tokenizer::TokenizerBase)
      @@tokenizer = tokenizer
    end

    def bigrams(sequence, start_symbol = nil, end_symbol = nil)
      ngrams(sequence, 2, start_symbol, end_symbol)
    end

    def trigrams(sequence, start_symbol = nil, end_symbol = nil)
      ngrams(sequence, 3, start_symbol, end_symbol)
    end

    def multigrams(sequence, n, start_symbol = nil, end_symbol = nil)
      ngrams(sequence, n, start_symbol, end_symbol)
    end

    def ngrams(sequence, n, start_symbol = nil, end_symbol = nil)
      result = [] of Array(String)

      unless sequence.is_a?(Array)
        sequence = @@tokenizer.tokenize(sequence)
      end

      sequence = sequence.not_nil! # TODO: Figure out why this is necessary
      count = [0, sequence.size - n + 1].max

      unless start_symbol.nil?
        blanks = [start_symbol] * n
        (1...n).to_a.reverse.each do |p|
          result.push(blanks[0, p] + sequence[0, n - p])
        end
      end

      (0...count).each do |i|
        result.push(sequence[i...(i + n)])
      end

      unless end_symbol.nil?
        blanks = [end_symbol] * n
        (1...n).to_a.reverse.each do |p|
          result.push(sequence[sequence.size - p, sequence.size] + blanks[0, n - p])
        end
      end

      result
    end
  end
end
