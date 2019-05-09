require "../spec_helper"

describe Cadmium::TfIdf do
  subject = Cadmium::TfIdf

  describe "stateless operations" do
    it "should tf" do
      Cadmium::TfIdf.tf("document", {key: "", terms: {"document" => 2.0, "one" => 1.0}}).should eq(2.0)
      Cadmium::TfIdf.tf("document", {key: "", terms: {"greetings" => 1.0, "program" => 1.0}}).should eq(0)
      Cadmium::TfIdf.tf("program", {key: "", terms: {"greetings" => 1.0, "program" => 1.0}}).should eq(1.0)
    end
  end

  describe "keys" do
    it "should store and recall keys" do
      tfidf = subject.new
      tfidf.add_document("document one", "un")
      tfidf.add_document("document Two", "deux")

      tfidf.tfidfs("two") do |i, _tfidf, key|
        if i == 0
          key.should eq("un")
        else
          key.should eq("deux")
        end
      end
    end

    it "should handle an array of documents passed to the initializer" do
      documents = [
        {key: "un", terms: {"document" => 1.0, "one" => 1.0}},
        {key: "deux", terms: {"document" => 1.0, "two" => 1.0}},
      ]
      tfidf = subject.new(documents)

      tfidf.tfidfs("two") do |i, _tfidf, key|
        if i == 0
          key.should eq("un")
        else
          key.should eq("deux")
        end
      end
    end

    it "should work when called without a block" do
      documents = [
        {key: "un", terms: {"document" => 1.0, "one" => 1.0}},
        {key: "deux", terms: {"document" => 1.0, "two" => 1.0}},
      ]
      tfidf = subject.new(documents)

      tfidfs = tfidf.tfidfs("two")
      tfidfs[1].should eq(1 + Math.log(2.0 / 2.0))
    end

    it "should work with restore_cache flag set to true" do
      tfidf = subject.new
      tfidf.add_document("document one", "un")

      tfidf.idf("one").should eq(1.0 + Math.log(2.0 / 2.0))

      tfidf.add_document("document Two", "deux", true)

      tfidf.tfidfs("two") do |i, _tfidf, key|
        if i == 0
          key.should eq("un")
        else
          key.should eq("deux")
        end
      end
    end
  end

  # describe "stateful operations" do
  #   tfidf = subject.new

  #   it "should list important terms" do
  #     tfidf.add_document("document one")
  #     tfidf.add_document("document two")
  #     terms = tfidf.list_terms(0)
  #     terms[0][:tfidf] > terms[1][:tfidf].should be_true
  #   end
  # end

  describe "correct calculations" do
    it "should compute idf correctly" do
      tfidf = subject.new
      tfidf.add_document("this document is about node.")
      tfidf.add_document("this document is about ruby.")
      tfidf.add_document("this document is about ruby and node.")
      tfidf.add_document("this document is about node. it has node examples")

      tfidf.idf("node").should eq(1.0 + Math.log(4.0 / 4.0))
    end

    it "should compute idf correctly with non-string documents" do
      tfidf = subject.new
      tfidf.add_document("this document is about node.")
      tfidf.add_document("this document is about ruby.")
      tfidf.add_document("this document is about ruby and node.")
      tfidf.add_document("this document is about node. it has node examples")
      tfidf.add_document("this document is about python")
      tfidf.add_document(["this", "document", "is", "about", "node", "and", "JavaScript"])

      tfidf.idf("node").should eq(1 + Math.log(6.0 / 5.0))
    end

    it "should compute tf correctly" do
      subject.tf("node", {key: "", terms: {"this" => 1.0, "document" => 1.0, "is" => 1.0, "about" => 1.0, "node" => 1.0}}).should eq(1.0)
      subject.tf("node", {key: "", terms: {"this" => 1.0, "document" => 1.0, "is" => 1.0, "about" => 1.0, "ruby" => 1.0}}).should eq(0.0)
      subject.tf("node", {key: "", terms: {"this" => 1.0, "document" => 1.0, "is" => 1.0, "about" => 1.0, "ruby" => 1.0, "and" => 1.0, "node" => 1.0}}).should eq(1.0)
      subject.tf("node", {key: "", terms: {"this" => 1.0, "document" => 1.0, "is" => 1.0, "about" => 1.0, "node" => 2.0, "it" => 1.0, "has" => 1.0, "examples" => 1.0}}).should eq(2.0)
    end
  end
end
