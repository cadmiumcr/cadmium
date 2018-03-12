require "../../spec_helper"

describe Cadmium::Distance::JaroWinkler do
  subject { described_class.new }

  it "should evaluate string similarity" do
    expect(subject.distance("DIXON", "DICKSONX")).to be_close(0.81333, 0.00001)
    expect(subject.distance("DWAYNE", "DUANE")).to be_close(0.84, 0.001)
  end

  it "should handle exact matches" do
    expect(subject.distance("RICK", "RICK")).to eq(1)
    expect(subject.distance("abc", "abc")).to eq(1)
    expect(subject.distance("abcd", "abcd")).to eq(1)
    expect(subject.distance("seddon", "seddon")).to eq(1)
  end

  it "should handle total mismatches" do
    expect(subject.distance("NOT", "SAME")).to eq(0)
  end

  it "should handle partial mismatches" do
    expect(subject.distance("aaa", "abcd")).to be_close(0.527, 0.001)
  end

  it "should handle transportations" do
    expect(subject.distance("MARTHA", "MARHTA")).to be_close(0.96111, 0.00001)
  end

  it "should handle transporations regardless of string order" do
    expect(subject.distance("class", "clams")).to be_close(0.90666, 0.00001)
    expect(subject.distance("clams", "class")).to be_close(0.90666, 0.00001)
  end
end
