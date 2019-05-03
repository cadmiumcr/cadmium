require "../../spec_helper"

describe Cadmium::Inflectors::CountInflector do
  subject = Cadmium::Inflectors::CountInflector

  it "should handle 1st cases" do
    subject.nth(1).should eq("1st")
    subject.nth(101).should eq("101st")
    subject.nth(11).should_not eq("11st")
    subject.nth(111).should_not eq("111st")
  end

  it "should handle the 12th cases" do
    subject.nth(12).should eq("12th")
    subject.nth(112).should eq("112th")
    subject.nth(1112).should eq("1112th")
  end

  it "should handle the 11th cases" do
    subject.nth(11).should eq("11th")
    subject.nth(111).should eq("111th")
    subject.nth(1111).should eq("1111th")
  end

  it "should handle the 13th cases" do
    subject.nth(13).should eq("13th")
    subject.nth(113).should eq("113th")
    subject.nth(1113).should eq("1113th")
  end

  it "should handle the th cases" do
    subject.nth(10).should eq("10th")
    subject.nth(4).should eq("4th")
    subject.nth(400).should eq("400th")
    subject.nth(404).should eq("404th")
    subject.nth(5).should eq("5th")
    subject.nth(5000).should eq("5000th")
    subject.nth(5005).should eq("5005th")
    subject.nth(9).should eq("9th")
    subject.nth(90009).should eq("90009th")
    subject.nth(90000).should eq("90000th")
  end

  it "should handle 2nd cases" do
    subject.nth(2).should eq("2nd")
    subject.nth(12).should_not eq("12nd")
  end

  it "should handle 3rd cases" do
    subject.nth(3).should eq("3rd")
    subject.nth(13).should_not eq("13rd")
  end
end
