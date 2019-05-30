require "../../spec_helper"

describe Cadmium::BayesClassifier do
  subject = Cadmium::BayesClassifier

  describe "#initialize" do
    it "successfully initalizes all defaults" do
      classifier = subject.new
      classifier.tokenizer.should be_a(Cadmium::WordTokenizer)
      classifier.vocabulary.should eq([] of String)
      classifier.total_documents.should eq(0)
      classifier.doc_count.should eq({} of String => Int32)
      classifier.word_count.should eq({} of String => Int32)
      classifier.word_frequency_count.should eq({} of String => Hash(String, Int32))
      classifier.categories.should eq([] of String)
    end

    it "uses a custom tokenizer" do
      classifier = subject.new(tokenizer: Cadmium::AggressiveTokenizer.new(lang: :en))
      classifier.tokenizer.should be_a(Cadmium::AggressiveTokenizer)
    end
  end

  describe "#train" do
    it "adds categories" do
      classifier = subject.new
      classifier.train("crystal is an awesome programming language", "programming")
      classifier.train("ruby is nice, but not as fast as crystal", "programming")
      classifier.train("my wife and I went to the beach", "off-topic")
      classifier.train("my dog likes to go outside and play", "off-topic")
      classifier.categories.should contain("programming")
      classifier.categories.should contain("off-topic")
    end

    it "increases the total_documents count" do
      classifier = subject.new
      classifier.train("crystal is an awesome programming language", "programming")
      classifier.train("ruby is nice, but not as fast as crystal", "programming")

      classifier.total_documents.should eq(2)

      classifier.train("my wife and I went to the beach", "off-topic")
      classifier.train("my dog likes to go outside and play", "off-topic")

      classifier.total_documents.should eq(4)
    end

    it "adds words to the vocabulary list" do
      classifier = subject.new
      classifier.train("crystal is an awesome programming language", "programming")
      classifier.vocabulary.should eq(["crystal", "is", "an", "awesome", "programming", "language"])
    end
  end

  describe "#categorize" do
    it "correctly categorizes `positive` and `negative` categories" do
      classifier = subject.new

      # teach it positive phrases
      classifier.train("amazing, awesome movie!! Yeah!!", "positive")
      classifier.train("Sweet, this is incredibly, amazing, perfect, great!!", "positive")

      # teach it a negative phrase
      classifier.train("terrible, shitty thing. Damn. Sucks!!", "negative")

      # teach it a neutral phrase
      classifier.train("I dont really know what to make of this.", "neutral")

      classifier.categorize("awesome, cool, amazing!! Yay.").should eq("positive")
      classifier.categorize("This is a damn shitty awful thing!").should eq("negative")
    end

    it "correctly categorizes `programming` and `off-topic`" do
      classifier = subject.new

      # some programming data
      classifier.train("crystal is an awesome programming language", "programming")
      classifier.train("ruby is nice, but not as fast as crystal", "programming")

      # some off topic data
      classifier.train("my wife and I went to the beach", "off-topic")
      classifier.train("my dog likes to go outside and play", "off-topic")

      classifier.categorize("this post is about crystal").should eq("programming")
      classifier.categorize("i don't know what I'm about").should eq("off-topic")
    end

    it "handles unicode characters" do
      classifier = subject.new

      classifier.train("Omg I love you so much 💕", "positive")
      classifier.train("You're the best! 😍😄", "positive")
      classifier.train("Damn you suck 👎", "negative")
      classifier.train("You are such a 💩 head", "negative")

      classifier.categorize("I love you 💕").should eq("positive")
      classifier.categorize("This sucks 👎").should eq("negative")
    end
  end

  describe "json serialization and deserialization" do
    classifier_json = "{\"vocabulary\":[\"crystal\",\"is\",\"an\",\"awesome\",\"programming\",\"language\",\"ruby\",\"nice\",\"but\",\"not\",\"as\",\"fast\",\"my\",\"wife\",\"and\",\"I\",\"went\",\"to\",\"the\",\"beach\",\"dog\",\"likes\",\"go\",\"outside\",\"play\"],\"total_documents\":4,\"doc_count\":{\"programming\":2,\"off-topic\":2},\"word_count\":{\"programming\":15,\"off-topic\":16},\"word_frequency_count\":{\"programming\":{\"crystal\":2,\"is\":2,\"an\":1,\"awesome\":1,\"programming\":1,\"language\":1,\"ruby\":1,\"nice\":1,\"but\":1,\"not\":1,\"as\":2,\"fast\":1},\"off-topic\":{\"my\":2,\"wife\":1,\"and\":2,\"I\":1,\"went\":1,\"to\":2,\"the\":1,\"beach\":1,\"dog\":1,\"likes\":1,\"go\":1,\"outside\":1,\"play\":1}},\"categories\":[\"programming\",\"off-topic\"]}"

    it "exports a trained set to a json document" do
      classifier = subject.new

      classifier.train("crystal is an awesome programming language", "programming")
      classifier.train("ruby is nice, but not as fast as crystal", "programming")
      classifier.train("my wife and I went to the beach", "off-topic")
      classifier.train("my dog likes to go outside and play", "off-topic")

      json = classifier.to_json
      json.should eq(classifier_json)
    end

    it "creates a new classifier from a json document" do
      classifier = subject.from_json(classifier_json)
      classifier.total_documents.should eq(4)
    end
  end

  describe "yaml serialization and deserialization" do
    classifier_yaml = "---\nvocabulary:\n- crystal\n- is\n- an\n- awesome\n- programming\n- language\n- ruby\n- nice\n- but\n- not\n- as\n- fast\n- my\n- wife\n- and\n- I\n- went\n- to\n- the\n- beach\n- dog\n- likes\n- go\n- outside\n- play\ntotal_documents: 4\ndoc_count:\n  programming: 2\n  off-topic: 2\nword_count:\n  programming: 15\n  off-topic: 16\nword_frequency_count:\n  programming:\n    crystal: 2\n    is: 2\n    an: 1\n    awesome: 1\n    programming: 1\n    language: 1\n    ruby: 1\n    nice: 1\n    but: 1\n    not: 1\n    as: 2\n    fast: 1\n  off-topic:\n    my: 2\n    wife: 1\n    and: 2\n    I: 1\n    went: 1\n    to: 2\n    the: 1\n    beach: 1\n    dog: 1\n    likes: 1\n    go: 1\n    outside: 1\n    play: 1\ncategories:\n- programming\n- off-topic\n"

    it "exports a trained set to a yaml document" do
      classifier = subject.new

      classifier.train("crystal is an awesome programming language", "programming")
      classifier.train("ruby is nice, but not as fast as crystal", "programming")
      classifier.train("my wife and I went to the beach", "off-topic")
      classifier.train("my dog likes to go outside and play", "off-topic")

      yaml = classifier.to_yaml
      yaml.should eq(classifier_yaml)
    end

    it "creates a new classifier from a yaml document" do
      classifier = subject.from_yaml(classifier_yaml)
      classifier.total_documents.should eq(4)
    end
  end
end
