require "../spec_helper"

describe Cadmium::NGrams do
  subject { described_class }

  it "should bigram a string via ngrams" do
    expect(subject.ngrams("these are some words", 2)).to eq([["these", "are"], ["are", "some"], ["some", "words"]])
  end

  it "should bigram an array of tokens via ngrams" do
    expect(subject.ngrams(["these", "are", "some", "words"], 2)).to eq([["these", "are"], ["are", "some"], ["some", "words"]])
  end

  it "should trigram a string via ngrams" do
    expect(subject.ngrams("these are some words", 3)).to eq([["these", "are", "some"], ["are", "some", "words"]])
  end

  it "should trigram an array of tokens via ngrams" do
    expect(subject.ngrams(["these", "are", "some", "words"], 3)).to eq([["these", "are", "some"], ["are", "some", "words"]])
  end

  describe ".bigrams" do
    it "should bigram a string" do
      expect(subject.bigrams("these are some words")).to eq([["these", "are"], ["are", "some"], ["some", "words"]])
    end

    it "should bigram an array of tokens" do
      expect(subject.bigrams(["these", "are", "some", "words"])).to eq([["these", "are"], ["are", "some"], ["some", "words"]])
    end
  end

  describe ".trigrams" do
    it "should trigram a string" do
      expect(subject.trigrams("these are some words")).to eq([["these", "are", "some"], ["are", "some", "words"]])
    end

    it "should trigram an array of tokens" do
      expect(subject.trigrams(["these", "are", "some", "words"])).to eq([["these", "are", "some"], ["are", "some", "words"]])
    end
  end

  it "should bigram a string with start and end symbols" do
    expect(subject.ngrams("these are some words", 2, "[start]", "[end]")).to eq([
        ["[start]", "these"],
        ["these", "are"],
        ["are", "some" ],
        ["some", "words"],
        ["words", "[end]"]
    ])
  end

  it "should bigram a string with start symbols only" do
    expect(subject.ngrams("these are some words", 2, "[start]")).to eq([
        ["[start]", "these"],
        ["these", "are"],
        ["are", "some" ],
        ["some", "words"]
    ])
  end

  it "should bigram a string with end symbols only" do
    expect(subject.ngrams("these are some words", 2, nil, "[end]")).to eq([
        ["these", "are"],
        ["are", "some" ],
        ["some", "words"],
        ["words", "[end]"]
    ])
  end

  it "should trigram a string with start and end symbols" do
    expect(subject.ngrams("these are some words", 3, "[start]", "[end]")).to eq([
      ["[start]", "[start]", "these"],
      ["[start]", "these", "are"],
      ["these", "are", "some"],
      ["are", "some", "words"],
      ["some", "words", "[end]"],
      ["words", "[end]", "[end]"]
    ])
  end

  it "should 4-gram a string with start and end symbols" do
    expect(subject.ngrams("these are some words", 4, "[start]", "[end]")).to eq([
      ["[start]", "[start]", "[start]", "these"],
      ["[start]", "[start]", "these", "are"],
      ["[start]", "these", "are", "some"],
      ["these", "are", "some", "words"],
      ["are", "some", "words", "[end]"],
      ["some", "words", "[end]", "[end]"],
      ["words", "[end]", "[end]", "[end]"]
    ])
  end

  it "should use an alternate tokenizer" do
    subject.tokenizer = Cadmium::Tokenizer::AggressiveTokenizer.new(lang: :fr)
    expect(subject.ngrams("Un Éléphant rouge", 2)).to eq([["Un", "Éléphant"], ["Éléphant", "rouge" ]])
  end
end
