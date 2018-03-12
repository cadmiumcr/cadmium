require "../../spec_helper"

describe Cadmium::Tokenizer::SentenceTokenizer do
  subject { described_class.new }

  it "should tokenize strings and trim whitespace" do
    expect(subject.tokenize("This is a sentence. This is another sentence.")).to eq(["This is a sentence.", "This is another sentence."])
  end

  it "should tokenize strings via String#tokenize" do
    expect("This is a sentence. This is another sentence.".tokenize(Cadmium::Tokenizer::SentenceTokenizer)).to eq(["This is a sentence.", "This is another sentence."])
  end

  it "should include quotation marks" do
    expect(subject.tokenize(%{"This is a sentence." This is another sentence.})).to eq(["\"This is a sentence.\"", "This is another sentence."])
  end

  it "should include brackets" do
    expect(subject.tokenize("This is a sentence. [This is another sentence.]")).to eq(["This is a sentence.", "[This is another sentence.]"])
  end
end
