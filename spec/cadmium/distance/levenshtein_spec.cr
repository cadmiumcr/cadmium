require "../../spec_helper"

describe Cadmium::Distance::Levenshtein do
  subject = Cadmium::Distance::Levenshtein

  it "should replace 2" do
    subject.distance("doctor", "doktor").should eq(1)
  end

  it "should delete 1" do
    subject.distance("doctor", "docto").should eq(1)
  end

  it "should insert 1" do
    subject.distance("flat", "flats").should eq(1)
  end

  it "should combine operations" do
    subject.distance("flad", "flaten").should eq(3)
    subject.distance("flaten", "flad").should eq(3)
  end

  it "should consider perfect matches 0" do
    subject.distance("one", "one").should eq(0)
  end

  it "should delete all characters" do
    subject.distance("delete", "").should eq(6)
  end

  it "should insert all characters" do
    subject.distance("", "insert").should eq(6)
  end
end
