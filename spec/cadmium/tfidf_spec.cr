require "../spec_helper"

describe Cadmium::TfIdf do
  describe "stateless operations" do
    it "should tf" do
      expect(Cadmium::TfIdf.tf("document", {terms: {"document" => 2, "one" => 1}})).to eq(2)
      expect(Cadmium::TfIdf.tf("document", {terms: {"greetings" => 1, "program" => 1}})).to eq(0)
      expect(Cadmium::TfIdf.tf("program", {terms: {"greetings" => 1, "program" => 1}})).to eq(1)
    end
  end

  describe "keys" do
    it "should store and recall keys" do
      tfidf = described_class.new
      tfidf.add_document("document one", "un")
      tfidf.add_document("document Two", "deux")

      tfidf.tfidfs("two") do |i, _tfidf, key|
        if i == 0
          expect(key).to eq("un")
        else
          expect(key).to eq("deux")
        end
      end
    end

    it "should handle an array of documents passed to the initializer" do
      documents = [
        {key: "un", terms: {"document" => 1.0, "one" => 1.0}},
        {key: "deux", terms: {"document" => 1.0, "two" => 1.0}},
      ]
      tfidf = described_class.new(documents)

      tfidf.tfidfs("two") do |i, _tfidf, key|
        if i == 0
          expect(key).to eq("un")
        else
          expect(key).to eq("deux")
        end
      end
    end

    it "should work when called without a block" do
      documents = [
        {key: "un", terms: {"document" => 1.0, "one" => 1.0}},
        {key: "deux", terms: {"document" => 1.0, "two" => 1.0}},
      ]
      tfidf = described_class.new(documents)

      tfidfs = tfidf.tfidfs("two")
      expect(tfidfs[1]).to eq(1 + Math.log(2.0 / 2.0))
    end

    it "should work with restore_cache flag set to true" do
      tfidf = described_class.new
      tfidf.add_document("document one", "un")

      expect(tfidf.idf("one")).to eq(1 + Math.log(2.0 / 2.0))

      tfidf.add_document("document Two", "deux", true)

      tfidf.tfidfs("two") do |i, _tfidf, key|
        if i == 0
          expect(key).to eq("un")
        else
          expect(key).to eq("deux")
        end
      end
    end
  end

  describe "stateful operations" do
    subject { described_class.new }

    before do
      subject.add_document("document one")
      subject.add_document("document two")
    end

    it "should list important terms" do
      terms = subject.list_terms(0)
      expect(terms[0][:tfidf] > terms[1][:tfidf]).to be_true
    end
  end

  describe "correct calculations" do
    it "should compute idf correctly" do
      tfidf = described_class.new
      tfidf.add_document("this document is about node.")
      tfidf.add_document("this document is about ruby.")
      tfidf.add_document("this document is about ruby and node.")
      tfidf.add_document("this document is about node. it has node examples")

      expect(tfidf.idf("node")).to eq(1 + Math.log(4.0 / 4.0))
    end

    it "should compute idf correctly with non-string documents" do
      tfidf = described_class.new
      tfidf.add_document("this document is about node.")
      tfidf.add_document("this document is about ruby.")
      tfidf.add_document("this document is about ruby and node.")
      tfidf.add_document("this document is about node. it has node examples")
      tfidf.add_document("this document is about python")
      tfidf.add_document(["this", "document", "is", "about", "node", "and", "JavaScript"])

      expect(tfidf.idf("node")).to eq(1 + Math.log(6.0 / 5.0))
    end

    it "should compute tf correctly" do
      expect(described_class.tf("node", {terms: {"this" => 1, "document" => 1, "is" => 1, "about" => 1, "node" => 1}})).to eq(1)
      expect(described_class.tf("node", {terms: {"this" => 1, "document" => 1, "is" => 1, "about" => 1, "ruby" => 1}})).to eq(0)
      expect(described_class.tf("node", {terms: {"this" => 1, "document" => 1, "is" => 1, "about" => 1, "ruby" => 1, "and" => 1, "node" => 1}})).to eq(1)
      expect(described_class.tf("node", {terms: {"this" => 1, "document" => 1, "is" => 1, "about" => 1, "node" => 2, "it" => 1, "has" => 1, "examples" => 1}})).to eq(2)
    end
  end
end
