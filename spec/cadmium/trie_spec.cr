# Based on https://github.com/NaturalNode/natural/blob/master/spec/trie_spec.js
#
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
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require "../spec_helper"

describe Cadmium::Trie do
  describe "#add" do
    it "should add words one at a time" do
      trie = described_class.new
      trie.add "test"
      expect(trie.contains? "test").to be_true
    end

    it "should return false if a string is added that did not already exist" do
      trie = described_class.new
      expect(trie.add "test").to be_false
    end

    it "should return true if a string is added that already existed" do
      trie = described_class.new
      trie.add "test"
      expect(trie.add "test").to be_true
    end

    it "should add an array of strings" do
      trie = described_class.new
      test_words = ["test", "abcd", "ffff"]
      trie.add test_words

      test_words.each {|word|
        expect(trie.contains? word).to be_true
      }
    end

    it "should return false if all the strings that were added did not already exist" do
      trie = described_class.new
      expect(trie.add ["test", "abcd"]).to be_false
    end

    it "should return false if any of the strings that were added did not already exist" do
      trie = described_class.new
      trie.add ["test", "abcd"]
      expect(trie.add ["test", "abcd", "foo"]).to be_false
    end

    it "should return true if all of the strings that were added already existed" do
      trie = described_class.new
      trie.add ["test", "abcd"]
      expect(trie.add ["test", "abcd"]).to be_true
    end
  end

  describe "#contains?" do
    it "should not find words that haven't been added" do
      trie = described_class.new
      expect(trie.contains? "aaaaa").to be_false
    end

    it "should find words that have been added" do
      trie = described_class.new
      trie.add "test"
      expect(trie.contains? "test").to be_true
    end

    it "should not return prefixes of words that haven't been added as words" do
      trie = described_class.new
      trie.add "test"
      expect(trie.contains? "te").to be_false
    end

    it "should not return suffixes of words that haven't been added as words" do
      trie = described_class.new
      trie.add "test"
      expect(trie.contains? "est").to be_false
    end

    it "should not find a word that falls between two other words but has not been added" do
      trie = described_class.new
      trie.add "test"
      trie.add "tested"
      expect(trie.contains? "teste").to be_false
    end

    context "case insensitive" do
      it "should be case sensitive by default" do
        trie = described_class.new
        trie.add "test"
        expect(trie.contains? "TEST").to be_false
      end
    end

    context "case sensitive" do
      it "should find contained prefixes case insensitively" do
        trie = described_class.new(case_sensitive: false)
        trie.add "test"
        expect(trie.contains? "TEST").to be_true
      end

      it "should case-insensitively find contained prefixes that were added with case" do
        trie = described_class.new(case_sensitive: false)
        trie.add "teSt"
        expect(trie.contains? "test").to be_true
      end
    end
  end

  describe "#matches_on_path" do
    it "should find full prefix matched words along a path" do
      trie = described_class.new
      trie.add ["a", "ab", "bc", "cd", "abc"]
      results = trie.matches_on_path "abcd"
      expect(results.includes? "a").to be_true
      expect(results.includes? "ab").to be_true
      expect(results.includes? "abc").to be_true
    end

    it "should not find prefixes that do not occur along a path" do
      trie = described_class.new
      trie.add ["a", "ab", "bc", "cd", "abc"]
      results = trie.matches_on_path "abcd"
      expect(results.includes? "bc").to be_false
      expect(results.includes? "cd").to be_false
    end

    context "case insensitive" do
      it "should find matches of differing case" do
        trie = described_class.new(case_sensitive: false)
        trie.add ["a", "ab", "bc", "cd", "abc"]
        results = trie.matches_on_path "ABCD"
        expect(results.includes? "abc").to be_true
      end
    end
  end

  describe "#keys_with_prefix" do
    it "should guess all full prefix matched words" do
      trie = described_class.new
      trie.add ["a", "ab", "bc", "cd", "abc"]
      results = trie.keys_with_prefix "a"
      expect(results.includes? "a").to be_true
      expect(results.includes? "ab").to be_true
      expect(results.includes? "abc").to be_true
    end

    it "should not guess words without the prefix" do
      trie = described_class.new
      trie.add ["a", "ab", "bc", "cd", "abc"]
      results = trie.keys_with_prefix "a"
      expect(results.includes? "bc").to be_false
      expect(results.includes? "cd").to be_false
    end

    it "should return an empty array if no full prefix matches were found" do
      trie = described_class.new
      trie.add ["a", "ab", "bc", "cd", "abc"]
      results = trie.keys_with_prefix "not-found"
      expect(results.size).to eq(0)
    end

    context "case insensitive" do
      it "should find keys of differing case" do
        trie = described_class.new(case_sensitive: false)
        trie.add ["a", "ab", "bc", "cd", "abc"]
        results = trie.keys_with_prefix "A"
        expect(results.includes? "abc").to be_true
      end
    end
  end

  describe "#find_prefix" do
    it "finds a complete prefix contained in the Trie" do
      trie = described_class.new
      trie.add ["their", "and", "they"]
      expect(trie.find_prefix "they").to eq({"they", ""})
    end

    it "finds a partial prefix contained in the Trie" do
      trie = described_class.new
      trie.add ["their", "and", "they"]
      expect(trie.find_prefix "theyre").to eq({"they", "re"})
    end

    it "executes the search without a match" do
      trie = described_class.new
      trie.add ["their", "and"]
      expect(trie.find_prefix "theyre").to eq({nil, "yre"})
    end

    context "case insensitive" do
      it "should match prefixes of differing case" do
        trie = described_class.new(case_sensitive: false)
        trie.add ["their", "and", "they"]
        expect(trie.find_prefix "THEYRE").to eq({"they", "re"})
      end
    end
  end

  describe "#size" do
    it "should return 1 for an empty trie" do
      trie = described_class.new
      expect(trie.size).to eq(1)
    end

    it "should return the correct size for a single character" do
      trie = described_class.new
      trie.add "a"
      expect(trie.size).to eq(2)
    end

    it "should count single branches together" do
      trie = described_class.new
      trie.add "a"
      trie.add "ab"
      expect(trie.size).to eq(3)
    end

    it "should count ragged branches" do
      trie = described_class.new
      trie.add "a"
      trie.add "ba"
      expect(trie.size).to eq(4)
    end

    it "should count branches that split in different directions" do
      trie = described_class.new
      trie.add "meet"
      trie.add "meek"
      expect(trie.size).to eq(6)
    end
  end
end
