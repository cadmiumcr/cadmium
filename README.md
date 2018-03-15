# Cadmium

Cadmium is a Natrual Language Processing (NLP) library for Crystal. Included are classes and modules for tokenizing, inflecting, stemming, and creating n-grams with much more to come.

It's still in early development, but tests are being written as I go so hopefully it will be somewhat stable.

This library is heavily based on the [natural](https://github.com/NaturalNode/natural) library for node.js, and as such you can expect the API's to be very similar. As a point of fact, most of the specs for Cadmium were copied directly from natural and lightly modified.

Any utilities that can be internationalized will be eventually. For now English is the primary concern.

## Table of Contents

- [Installation](#installation)
- [Tokenizers](#tokenizers)
- [String Distance](#string-distance)
- [Stemmers](#stemmers)
- [Inflectors](#inflectors)
- [N-Grams](#n-grams)
- [tf-idf](#tf-idf)
- [tf-idf](#transliterator)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [Contributors](#contributors)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cadmium:
    github: watzon/cadmium
    branch: master
```

## Usage

Require the cadmium library in your project

```crystal
require "cadmium"
```

### Tokenizers

Cadmium includes several different tokenizers, each of which is useful for different applications.

#### Aggressive Tokenizer

The aggressive tokenizer currently has localization available for English (:en / nil), Spanish (:es), Persian (:fa), French (:fr), Indonesian (:id), Dutch (:nl), Norwegian (:no), Polish (:pl), Portuguese (:pt), Russian (:ru), and Swedish (:sv). If no language is included it will

Use it like so:

```crystal
tokenizer = Cadmium::Tokenizer::AggressiveTokenizer.new(lang: :es)
tokenizer.tokenize("hola yo me llamo eduardo y esudié ingeniería")
# => ["hola", "yo", "me", "llamo", "eduardo", "y", "esudié", "ingeniería"]
``` 

#### Case Tokenizer

The case tokenizer doesn't rely on Regex and as such should be pretty fast. It should also work on an international basis fairly easily.

```crystal
tokenizer = Cadmium::Tokenizer::CaseTokenizer.new
tokenizer.tokenize("these are strings")
# => ["these", "are", "strings"]

tokenizer = Cadmium::Tokenizer::CaseTokenizer.new(preserve_apostrophes: true)
tokenizer.tokenize("Affectueusement surnommé « Gabo » dans toute l'Amérique latine")
# => ["Affectueusement", "surnommé", "Gabo", "dans", "toute", "l", "Amérique", "latine"]
```

#### Regex Tokenizer

The whitespace tokenizer, word punctuation tokenizer, and word tokenizer all extend the regex tokenizer. It uses Regex to match on the correct values.

```crystal
tokenizer = Cadmium::Tokenizer::WordPunctuationTokenizer.new
tokenizer.tokenize("my dog hasn't any fleas.")
# => ["my", "dog", "hasn", "'", "t", "any", "fleas", "."]
```

#### Treebank Word Tokenizer

The treebank tokenizer uses regular expressions to tokenize text as in Penn Treebank. This implementation is a port of the tokenizer sed script written by Robert McIntyre. To read about treebanks you can visit [wikipedia](https://en.wikipedia.org/wiki/Treebank).

```crystal
tokenizer = Cadmium::Tokenizer::TreebankWordTokenizer.new
tokenizer.tokenize("If we 'all' can't go. I'll stay home.")
# => ["If", "we", "'all", "'", "ca", "n't", "go.", "I", "'ll", "stay", "home", "."]
```

### String Distance

Corundum provides an implimentation of two different string distance algorithms, the [Jaro-Winkler Distance Algorithm](http://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance) and the [Levenshtein Distance Algorithm](https://en.wikipedia.org/wiki/Levenshtein_distance).

#### Jaro-Winkler

The Jaro-Winkler algorithm returns a number between 0 and 1 which tells how closely two strings match (1 being perfect and 0 being not at all).

```crystal
Cadmium.jaro_winkler_distance("dixon","dicksonx")
# => 0.8133333333333332

Cadmium.jaro_winkler_distance("same","same")
# => 1

Cadmium.jaro_winkler_distance("not","same")
# => 0.0
```

#### Levenshtein

The Levenshtein distance algorithm returns the number of edits (insertions, modifications, or deletions) required to transform one string into another.

```crystal
Cadmium.levenshtein_distance("doctor", "doktor")
# => 1

Cadmium.levenshtein_distance("doctor", "doctor")
# => 0

Cadmium.levenshtein_distance("flad", "flaten")
# => 3
```

### Stemmers

Currently Cadmium only comes with a [Porter](http://tartarus.org/martin/PorterStemmer/index.html) Stemmer, but [Lancaster](http://www.comp.lancs.ac.uk/computing/research/stemming/) will be added soon. Stemmer methods `stem` and `tokenize_and_stem` have also been added to the String class to simplify use.

```crystal
"words".stem
# => word

"i am waking up to the sounds of chainsaws".tokenize_and_stem
# => ["wake", "sound", "chainsaw"]
```

### Inflectors

#### Nouns

Nouns can be inflected using the `NounInflector` which has also been attached to the `String` class.

```crystal
inflector = Cadmium::Inflectors::NounInflector.new

inflector.pluralize("radius")
# => radii

inflector.singularize("radii")
# => radius

"person".pluralize
# => people

"people".singularize
# => person
```

#### Present Tense Verbs

Present tense verbs can be inflected with the `PresentTenseVerb` inflector. This has also been attached to the string class.

```crystal
inflector = Cadmium::Inflectors::PresentTenseVerb.new

inflector.singularize("become")
# => became

inflector.pluralize("became")
# => become

"walk".singularize(false) # noun: false
# => walks

"walks".pluralize(false)  # noun: false
# => walk
```

#### Numbers

Numbers can be inflected with the `CountInflector` which also adds a method `to_nth` to the `Int` class.

```crystal
Cadmium::Inflectors::CountInflector.nth(1)
# => 1st

Cadmium::Inflectors::CountInflector.nth(111)
# => 111th

153.to_nth
# => 153rd
```

### N-Grams

N-Grams can be obtained for Arrays of Strings, or with single Strings (which will first be tokenized).

#### bigrams

```crystal
Cadmium::NGrams.bigrams("these are some words")
# => [["these", "are"], ["are", "some"], ["some", "words"]]
```

#### trigrams

```crystal
Cadmium::NGrams.trigrams("these are some words")
# => [["these", "are", "some"], ["are", "some", "words"]]
```

#### arbitrary n-grams

```crystal
Cadmium::NGrams.ngrams("some other words here for you", 4)
# => [["some", "other", "words", "here"], ["other", "words", "here", "for"], ["words", "here", "for", "you"]]
```

#### padding

n-grams can also be returned with left or right padding by passing a start and/or end symbol to the bigrams, trigrams or ngrams.

```crystal
Cadmium::NGrams.ngrams("these are some words", 4, "[start]", "[end]")
# => [
      ["[start]", "[start]", "[start]", "these"],
      ["[start]", "[start]", "these", "are"],
      ["[start]", "these", "are", "some"],
      ["these", "are", "some", "words"],
      ["are", "some", "words", "[end]"],
      ["some", "words", "[end]", "[end]"],
      ["words", "[end]", "[end]", "[end]"]
    ]
```

### tf-idf

[Term Frequency–Inverse Document Frequency (tf-idf)](http://en.wikipedia.org/wiki/Tf%E2%80%93idf) is implemented to determine how important a word (or words) is to a document relative to a corpus. The following example will add four documents to a corpus and determine the weight of the word "node" and then the weight of the word "ruby" in each document.

```crystal
tfidf = Cadmium::TfIdf.new
tfidf.add_document("this document is about crystal.")
tfidf.add_document("this document is about ruby.")
tfidf.add_document("this document is about ruby and crystal.")
tfidf.add_document("this document is about crystal. it has crystal examples")

puts "crystal --------------------------------"
tfidf.tfidfs("crystal") do |i, measure, key|
  puts "document ##{i} is #{measure}"
end

puts "ruby --------------------------------"
tfidf.tfidfs("ruby") do |i, measure, key|
  puts "document ##{i} is #{measure}"
end

# =>  node --------------------------------
      document #0 is 1
      document #1 is 0
      document #2 is 1
      document #3 is 2
      ruby --------------------------------
      document #0 is 0
      document #1 is 1.2876820724517808
      document #2 is 1.2876820724517808
      document #3 is 0
```

### Transliterator

The Transliterator module provides the ability to transliterate UTF-8 strings into pure ASCII so that they can be safely displayed in URL slugs or file names.

```crystal
Cadmium.transliterate("Привет")
# => "Privet"

Cadmium.transliterate("你好朋友")
# => "Ni Hao Peng You"

# With the string extension

"މިއަދަކީ ހދ ރީތި ދވހކވ".transliterate
# => "mi'adhakee hdh reethi dhvhkv"

"こんにちは、友人".transliterate
# => konnichiwa, You Ren
```

## Roadmap

This is all I want to have done before a __v1.0__ release.

- [x] Tokenizers
  - [x] AggressiveTokenizer
    - [x] i18n
  - [x] CaseTokenizer
  - [x] RegexTokenizer
  - [x] SentenceTokenizer
  - [x] TreebankWordTokenizer
  - [x] WhitespaceTokenizer
  - [x] WordPunctuationTokenizer
- [x] String Distance
  - [x] Levenshein
    - [ ] Approximate String Matching
  - [x] JaroWinkler
- [ ] Stemmers
  - [x] PorterStemmer
    - [ ] i18n
  - [ ] LancasterStemmer
    - [ ] i18n
- [ ] Classifiers
    - [ ] Bayes
    - [ ] Logic Regression 
- [ ] Phonetics
- [x] Inflectors
  - [x] Count
  - [x] Noun
  - [x] Verb
  - [ ] i18n
- [x] N-Grams
- [x] TF-IDF
- [x] Transliterator
- [ ] Sentiment Analysis
- [ ] Tries
- [ ] EdgeWeightedDigraph
- [ ] ShortestPathTree
- [ ] LongestPathTree
- [ ] WordNet
- [ ] Spellcheck
- [ ] POS Tagger

## Contributing

1. Fork it ( https://github.com/watzon/cadmium/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [watzon](https://github.com/watzon) Chris Watson - creator, maintainer
