require "../../spec_helper"

describe Cadmium::Inflectors::CountInflector do
  subject { described_class }

  it "should handle 1st cases" do
    expect(subject.nth(1)).to eq("1st")
    expect(subject.nth(101)).to eq("101st")
    expect(subject.nth(11)).not_to eq("11st")
    expect(subject.nth(111)).not_to eq("111st")
  end

  it "should handle the 12th cases" do
    expect(subject.nth(12)).to eq("12th")
    expect(subject.nth(112)).to eq("112th")
    expect(subject.nth(1112)).to eq("1112th")
  end

  it "should handle the 11th cases" do
    expect(subject.nth(11)).to eq("11th")
    expect(subject.nth(111)).to eq("111th")
    expect(subject.nth(1111)).to eq("1111th")
  end

  it "should handle the 13th cases" do
    expect(subject.nth(13)).to eq("13th")
    expect(subject.nth(113)).to eq("113th")
    expect(subject.nth(1113)).to eq("1113th")
  end

  it "should handle the th cases" do
    expect(subject.nth(10)).to eq("10th")
    expect(subject.nth(4)).to eq("4th")
    expect(subject.nth(400)).to eq("400th")
    expect(subject.nth(404)).to eq("404th")
    expect(subject.nth(5)).to eq("5th")
    expect(subject.nth(5000)).to eq("5000th")
    expect(subject.nth(5005)).to eq("5005th")
    expect(subject.nth(9)).to eq("9th")
    expect(subject.nth(90009)).to eq("90009th")
    expect(subject.nth(90000)).to eq("90000th")
  end

  it "should handle 2nd cases" do
    expect(subject.nth(2)).to eq("2nd")
    expect(subject.nth(12)).not_to eq("12nd")
  end

  it "should handle 3rd cases" do
    expect(subject.nth(3)).to eq("3rd")
    expect(subject.nth(13)).not_to eq("13rd")
  end
end
