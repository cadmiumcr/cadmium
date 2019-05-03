require "../spec_helper"

describe Cadmium::NGrams do
  subject = Cadmium::NGrams

  it "should bigram a string via ngrams" do
    subject.ngrams("these are some words", 2).should eq([["these", "are"], ["are", "some"], ["some", "words"]])
  end

  it "should bigram an array of tokens via ngrams" do
    subject.ngrams(["these", "are", "some", "words"], 2).should eq([["these", "are"], ["are", "some"], ["some", "words"]])
  end

  it "should trigram a string via ngrams" do
    subject.ngrams("these are some words", 3).should eq([["these", "are", "some"], ["are", "some", "words"]])
  end

  it "should trigram an array of tokens via ngrams" do
    subject.ngrams(["these", "are", "some", "words"], 3).should eq([["these", "are", "some"], ["are", "some", "words"]])
  end

  describe ".bigrams" do
    it "should bigram a string" do
      subject.bigrams("these are some words").should eq([["these", "are"], ["are", "some"], ["some", "words"]])
    end

    it "should bigram an array of tokens" do
      subject.bigrams(["these", "are", "some", "words"]).should eq([["these", "are"], ["are", "some"], ["some", "words"]])
    end
  end

  describe ".trigrams" do
    it "should trigram a string" do
      subject.trigrams("these are some words").should eq([["these", "are", "some"], ["are", "some", "words"]])
    end

    it "should trigram an array of tokens" do
      subject.trigrams(["these", "are", "some", "words"]).should eq([["these", "are", "some"], ["are", "some", "words"]])
    end
  end

  it "should bigram a string with start and end symbols" do
    subject.ngrams("these are some words", 2, "[start]", "[end]").should eq([
      ["[start]", "these"],
      ["these", "are"],
      ["are", "some"],
      ["some", "words"],
      ["words", "[end]"],
    ])
  end

  it "should bigram a string with start symbols only" do
    subject.ngrams("these are some words", 2, "[start]").should eq([
      ["[start]", "these"],
      ["these", "are"],
      ["are", "some"],
      ["some", "words"],
    ])
  end

  it "should bigram a string with end symbols only" do
    subject.ngrams("these are some words", 2, nil, "[end]").should eq([
      ["these", "are"],
      ["are", "some"],
      ["some", "words"],
      ["words", "[end]"],
    ])
  end

  it "should trigram a string with start and end symbols" do
    subject.ngrams("these are some words", 3, "[start]", "[end]").should eq([
      ["[start]", "[start]", "these"],
      ["[start]", "these", "are"],
      ["these", "are", "some"],
      ["are", "some", "words"],
      ["some", "words", "[end]"],
      ["words", "[end]", "[end]"],
    ])
  end

  it "should 4-gram a string with start and end symbols" do
    subject.ngrams("these are some words", 4, "[start]", "[end]").should eq([
      ["[start]", "[start]", "[start]", "these"],
      ["[start]", "[start]", "these", "are"],
      ["[start]", "these", "are", "some"],
      ["these", "are", "some", "words"],
      ["are", "some", "words", "[end]"],
      ["some", "words", "[end]", "[end]"],
      ["words", "[end]", "[end]", "[end]"],
    ])
  end

  it "should use an alternate tokenizer" do
    subject.tokenizer = Cadmium::Tokenizer::AggressiveTokenizer.new(lang: :fr)
    subject.ngrams("Un Éléphant rouge", 2).should eq([["Un", "Éléphant"], ["Éléphant", "rouge"]])
  end
end
