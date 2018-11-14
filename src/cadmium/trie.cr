# Legal stuff:
#
# Copyright (c) 2014 Ken Koch
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

module Cadmium
  class Trie
    @dictionary = {} of Char => Trie
    @is_end = false

    protected getter dictionary

    def initialize(@case_sensitive = true)
    end

    def add(string : String)
      string = string.downcase unless @case_sensitive
      chars = string.chars
      add(chars)
    end

    def add(strings : Array(String))
      strings.reduce(true) {|memo, string| add(string) && memo }
    end

    protected def add(chars : Array(Char))
      if chars.empty?
        was_end = @is_end
        @is_end = true
        return was_end
      end
      
      first_letter = chars.shift

      unless next_node = @dictionary[first_letter]?
        @dictionary[first_letter] = Trie.new
        next_node = @dictionary[first_letter]
      end

      next_node.add chars
    end

    def contains?(string)
      string = string.downcase unless @case_sensitive
      contains? string.chars
    end

    protected def contains?(chars : Array(Char))
      return @is_end if chars.empty?

      first_letter = chars.shift

      unless next_node = @dictionary[first_letter]?
        return false
      end

      next_node.contains? chars
    end

    def find_prefix(lookup)
      lookup = lookup.downcase unless @case_sensitive
      collect_prefix_and_suffix(self, lookup.chars, [] of Char, nil)
    end

    private def collect_prefix_and_suffix(node, search, matched_chars, last)
      last = matched_chars.join if node.end?

      return {last, ""} if search.empty?

      unless next_node = node.dictionary[search[0]]?
          return {last, search.join}
      end

      matched_chars.push search.shift
      collect_prefix_and_suffix(next_node, search, matched_chars, last)
    end

    def keys_with_prefix(prefix)
      results = [] of String
      prefix = prefix.downcase unless @case_sensitive
      node = get_node_with_prefix(self, prefix.chars)
      collect_keys_beginning_with_prefix(node, prefix, results)
      results
    end

    private def get_node_with_prefix(node, prefix)
      return nil unless node
      return node if prefix.empty?
      return get_node_with_prefix(node.dictionary[prefix.shift]?, prefix)
    end

    private def collect_keys_beginning_with_prefix(node, builder, results)
      return unless node

      results.push builder if node.end?

      return if node.dictionary.empty?

      node.dictionary.each {|c, next_node|
        collect_keys_beginning_with_prefix(next_node, builder+c, results)
      }
    end

    def matches_on_path(path)
      path = path.downcase unless @case_sensitive
      collect_matches_on_path(self, path.chars, "", [] of String)
    end

    private def collect_matches_on_path(node, lookup, builder, results)
      results.push builder if node.end?

      return results if lookup.empty?

      first_letter = lookup[0]
      unless next_node = node.dictionary[first_letter]?
        return results
      end

      collect_matches_on_path(next_node, lookup[1..-1], builder + first_letter, results)
    end

    def size
      @dictionary.sum(1) {|c, node| node.size }
    end

    protected def end?
      @is_end
    end
  end
end
