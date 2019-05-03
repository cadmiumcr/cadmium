require "../../spec_helper"

describe Cadmium::Distance::JaroWinkler do
  subject = Cadmium::Distance::JaroWinkler.new

  it "should evaluate string similarity" do
    subject.distance("DIXON", "DICKSONX").should be_close(0.81333, 0.00001)
    subject.distance("DWAYNE", "DUANE").should be_close(0.84, 0.001)
  end

  it "should handle exact matches" do
    subject.distance("RICK", "RICK").should eq(1)
    subject.distance("abc", "abc").should eq(1)
    subject.distance("abcd", "abcd").should eq(1)
    subject.distance("seddon", "seddon").should eq(1)
  end

  it "should handle total mismatches" do
    subject.distance("NOT", "SAME").should eq(0)
  end

  it "should handle partial mismatches" do
    subject.distance("aaa", "abcd").should be_close(0.527, 0.001)
  end

  it "should handle transportations" do
    subject.distance("MARTHA", "MARHTA").should be_close(0.96111, 0.00001)
  end

  it "should handle transporations regardless of string order" do
    subject.distance("class", "clams").should be_close(0.90666, 0.00001)
    subject.distance("clams", "class").should be_close(0.90666, 0.00001)
  end
end
