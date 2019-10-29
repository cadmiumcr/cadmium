require "../../spec_helper"

describe Cadmium::Lemmatizer::WordNetLemmatizer do
  subject = Cadmium::Lemmatizer::WordNetLemmatizer

  it "should preform lemmatization" do
    subject.lemmatize("dogs").should eq("dog")
    subject.lemmatize("churches").should eq("church")
    subject.lemmatize("aardwolves").should eq("aardwolf")
    subject.lemmatize("abaci").should eq("abacus")
    subject.lemmatize("hardrock").should eq("hardrock")
  end

  it "should lemmatize with String#lemmatize" do
    "dogs".lemmatize.should eq("dog")
  end

  it "should tokenize and lemmatize with String#tokenize_and_lemmatize" do
    "My dogs are very fun TO play with And another thing, he is A poodle.".tokenize_and_lemmatize.should eq(["dog", "fun", "play", "poodle"])
  end

  it "should tokenize and lemmatize including stopwords" do
    "My dog is very fun TO play with And another thing, he is A poodle.".tokenize_and_lemmatize(keep_stops: true).should eq(["my", "dog", "be", "very", "fun", "to", "play", "with", "and", "another", "thing", "he", "be", "a", "poodle"])
  end
end
