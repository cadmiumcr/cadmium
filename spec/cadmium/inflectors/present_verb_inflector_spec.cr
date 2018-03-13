require "../../spec_helper"

describe Cadmium::Inflectors::PresentVerbInflector do
  subject { described_class.new }

  describe "#singularize" do
    it "should singularize regular ES forms" do
      expect(subject.singularize("catch")).to eq("catches")
      expect(subject.singularize("do")).to eq("does")
      expect(subject.singularize("go")).to eq("goes")
    end

    it "should handle [CS]HES forms" do
      expect(subject.singularize("cash")).to eq("cashes")
      expect(subject.singularize("ach")).to eq("aches")
    end

    it "should ignore XES forms" do
      expect(subject.singularize("annex")).to eq("annexes")
    end

    it "should handle SSES forms" do
      expect(subject.singularize("access")).to eq("accesses")
    end

    it "should ignore ZZES forms" do
      expect(subject.singularize("buzz")).to eq("buzzes")
    end

    it "should singularize regular S forms" do
      expect(subject.singularize("claim")).to eq("claims")
      expect(subject.singularize("drink")).to eq("drinks")
      expect(subject.singularize("become")).to eq("becomes")
    end

    it "should singularize irregular forms" do
      expect(subject.singularize("are")).to eq("is")
      expect(subject.singularize("were")).to eq("was")
      expect(subject.singularize("have")).to eq("has")
    end

    it "should singularize ies forms" do
      expect(subject.singularize("fly")).to eq("flies")
      expect(subject.singularize("try")).to eq("tries")
    end

    it "should handle ambiguous forms" do
      expect(subject.singularize("will")).to eq("will")
    end
  end

  describe "#pluralize" do
    it "should pluralize regular ES forms" do
      expect(subject.pluralize("catches")).to eq("catch")
      expect(subject.pluralize("does")).to eq("do")
      expect(subject.pluralize("goes")).to eq("go")
    end

    it "should handle [CS]HES forms" do
      expect(subject.pluralize("cashes")).to eq("cash")
      expect(subject.pluralize("aches")).to eq("ach")
    end

    it "should handle XES forms" do
      expect(subject.pluralize("annexes")).to eq("annex")
    end

    it "should handle SSES forms" do
      expect(subject.pluralize("accesses")).to eq("access")
    end

    it "should handle ZZES forms" do
      expect(subject.pluralize("buzzes")).to eq("buzz")
    end

    it "should pluralize regular S forms that done drop e" do
      expect(subject.pluralize("becomes")).to eq("become")
    end

    it "should pluralize regular S forms" do
      expect(subject.pluralize("drinks")).to eq("drink")
      expect(subject.pluralize("claims")).to eq("claim")
    end

    it "should pluralize irregular forms" do
      expect(subject.pluralize("was")).to eq("were")
      expect(subject.pluralize("is")).to eq("are")
      expect(subject.pluralize("am")).to eq("are")
      expect(subject.pluralize("has")).to eq("have")
    end

    it "should pluralize ies forms" do
      expect(subject.pluralize("flies")).to eq("fly")
      expect(subject.pluralize("tries")).to eq("try")
    end

    it "should handle ambiguous forms" do
      expect(subject.pluralize("will")).to eq("will")
    end
  end

  it "should pluralize and singularize string from patch" do
    expect("becomes".pluralize(false)).to eq("become")
    expect("become".singularize(false)).to eq("becomes")
  end
end
