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

    # Adds a string to the Trie
    #
    # Returns true if the string was already present, and false otherwise
    def add(string : String)
      string = string.downcase unless @case_sensitive
      add(string.chars)
    end

    # Adds an array of strings to the Trie
    #
    # Returns true if all of the strings were already present, and false otherwise
    def add(strings : Array(String))
      strings.reduce(true) {|memo, string| add(string) && memo }
    end

    # Helper method for adding to the Trie
    #
    # Works with Char arrays instead of Strings to avoid unnecessary
    # substringing.
    protected def add(chars : Array(Char))
      # If all of the characters have been exhausted, mark the current node as
      # the end of a word, and return whether the current node had already been
      # marked as such
      if chars.empty?
        was_end = @is_end
        @is_end = true
        return was_end
      end
      
      # Otherwise, carry on down the Trie
      first_letter = chars.shift
      unless next_node = @dictionary[first_letter]?
        @dictionary[first_letter] = Trie.new
        next_node = @dictionary[first_letter]
      end

      next_node.add chars
    end

    # Determines if *string* has been added to the Trie
    def contains?(string)
      string = string.downcase unless @case_sensitive
      contains? string.chars
    end

    # Helper method for finding an exact element in the Trie
    #
    # Works with Char arrays instead of Strings to avoid unnecessary
    # substringing.
    protected def contains?(chars : Array(Char))
      # If all of the characters have been exhausted, check if the current
      # node was marked as being the end of a word
      return @is_end if chars.empty?

      first_letter = chars.shift

      unless next_node = @dictionary[first_letter]?
        return false
      end

      next_node.contains? chars
    end

    # Finds the largest prefix matching the prefix of *lookup*
    #
    # Returns a 2-Tuple. If a prefix was found, it will be the first element;
    # otherwise, the first element will be nil. The second element will be the
    # substring that was not matched.
    def find_prefix(lookup)
      lookup = lookup.downcase unless @case_sensitive
      collect_prefix_and_suffix(self, lookup.chars, [] of Char, nil)
    end

    # Helper method for prefix finding
    private def collect_prefix_and_suffix(node, search, matched_chars, largest_prefix)
      # If the current node is marked as being the end of a word, update the
      # largest prefix
      largest_prefix = matched_chars.join if node.end?

      # If all of the characters have been exhausted or there is nowhere left
      # to go, return what was discovered to this point
      if search.empty? || !node.dictionary.has_key? search[0]
        return {largest_prefix, search.join}
      end

      # Otherwise, keep looking
      first_letter = search.shift
      next_node = node.dictionary[first_letter]
      matched_chars.push first_letter
      collect_prefix_and_suffix(next_node, search, matched_chars, largest_prefix)
    end

    # Finds all of the words that begin with *prefix*
    def keys_with_prefix(prefix)
      results = [] of String
      prefix = prefix.downcase unless @case_sensitive

      node = get_node_with_prefix(self, prefix.chars)
      collect_keys_beginning_with_prefix(node, prefix, results)
      results
    end

    # Finds the node corresponding to *prefix*
    #
    # Returns nil if there is no such node
    private def get_node_with_prefix(node, prefix)
      if !node
        nil
      elsif prefix.empty?
        node
      else
        get_node_with_prefix(node.dictionary[prefix.shift]?, prefix)
      end
    end

    # Helper function for key finding based on prefix
    #
    # Adds all of the words beginning with *prefix* into *results*
    private def collect_keys_beginning_with_prefix(node, prefix, results)
      return unless node

      results.push prefix if node.end?

      return if node.dictionary.empty?

      node.dictionary.each {|c, next_node|
        collect_keys_beginning_with_prefix(next_node, prefix+c, results)
      }
    end

    # Finds all of the words stored in the Trie that are found along *path*
    def matches_on_path(path)
      path = path.downcase unless @case_sensitive
      collect_matches_on_path(self, path.chars, [] of Char, [] of String)
    end

    # Helper function for finding matches on a path
    #
    # Adds all of the words along *path* into *results*
    private def collect_matches_on_path(node, path, match_builder, results)
      results.push match_builder.join if node.end?

      return results if path.empty?

      first_letter = path.shift
      unless next_node = node.dictionary[first_letter]?
        return results
      end

      match_builder.push first_letter
      collect_matches_on_path(next_node, path, match_builder, results)
    end

    # Returns the number of nodes in the Trie
    def size
      @dictionary.sum(1) {|c, node| node.size }
    end

    protected def end?
      @is_end
    end
  end
end
