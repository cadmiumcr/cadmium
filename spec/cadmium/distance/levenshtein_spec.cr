require "../../spec_helper"

describe Cadmium::Distance::Levenshtein do
  it "should replace 2" do
    expect(described_class.distance("doctor", "doktor")).to eq(1)
  end

  it "should delete 1" do
    expect(described_class.distance("doctor", "docto")).to eq(1)
  end

  it "should insert 1" do
    expect(described_class.distance("flat", "flats")).to eq(1)
  end

  it "should combine operations" do
    expect(described_class.distance("flad", "flaten")).to eq(3)
    expect(described_class.distance("flaten", "flad")).to eq(3)
  end

  it "should consider perfect matches 0" do
    expect(described_class.distance("one", "one")).to eq(0)
  end

  it "should delete all characters" do
    expect(described_class.distance("delete", "")).to eq(6)
  end

  it "should insert all characters" do
    expect(described_class.distance("", "insert")).to eq(6)
  end
end
