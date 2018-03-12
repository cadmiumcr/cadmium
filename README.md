# Cadmium

Natural Language Processing (NLP) library for Crystal.

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  cadmium:
    github: watzon/cadmium
```

## Usage

```crystal
require "cadmium"
```

## Development

### Progress

This is all I want to have done before a __v1.0__ release.

- [x] Tokenizers
  - [x] AggressiveTokenizer
    - [x] Multi-Lang
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
    - [ ] Multi-Lang
  - [ ] LancasterStemmer
    - [ ] Multi-Lang
- [ ] Classifiers
    - [ ] Bayes
    - [ ] Logic Regression 
- [ ] Phonetics
- [ ] Inflectors
- [x] N-Grams
- [ ] TF-IDF
- [ ] Sentiment Analysis
- [ ] Tries
- [ ] EdgeWeightedDigraph
- [ ] ShortestPathTree
- [ ] LongestPathTree
- [ ] WordNet
- [ ] Spellcheck
- [ ] POS Tagger
- [ ] Transliterator

## Contributing

1. Fork it ( https://github.com/watzon/cadmium/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [watzon](https://github.com/watzon) Chris Watson - creator, maintainer
