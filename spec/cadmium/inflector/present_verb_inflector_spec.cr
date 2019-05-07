require "../../spec_helper"

describe Cadmium::Inflector::PresentVerbInflector do
  subject = Cadmium::Inflector::PresentVerbInflector.new

  describe "#singularize" do
    it "should singularize regular ES forms" do
      subject.singularize("catch").should eq("catches")
      subject.singularize("do").should eq("does")
      subject.singularize("go").should eq("goes")
    end

    it "should handle [CS]HES forms" do
      subject.singularize("cash").should eq("cashes")
      subject.singularize("ach").should eq("aches")
    end

    it "should ignore XES forms" do
      subject.singularize("annex").should eq("annexes")
    end

    it "should handle SSES forms" do
      subject.singularize("access").should eq("accesses")
    end

    it "should ignore ZZES forms" do
      subject.singularize("buzz").should eq("buzzes")
    end

    it "should singularize regular S forms" do
      subject.singularize("claim").should eq("claims")
      subject.singularize("drink").should eq("drinks")
      subject.singularize("become").should eq("becomes")
    end

    it "should singularize irregular forms" do
      subject.singularize("are").should eq("is")
      subject.singularize("were").should eq("was")
      subject.singularize("have").should eq("has")
    end

    it "should singularize ies forms" do
      subject.singularize("fly").should eq("flies")
      subject.singularize("try").should eq("tries")
    end

    it "should handle ambiguous forms" do
      subject.singularize("will").should eq("will")
    end
  end

  describe "#pluralize" do
    it "should pluralize regular ES forms" do
      subject.pluralize("catches").should eq("catch")
      subject.pluralize("does").should eq("do")
      subject.pluralize("goes").should eq("go")
    end

    it "should handle [CS]HES forms" do
      subject.pluralize("cashes").should eq("cash")
      subject.pluralize("aches").should eq("ach")
    end

    it "should handle XES forms" do
      subject.pluralize("annexes").should eq("annex")
    end

    it "should handle SSES forms" do
      subject.pluralize("accesses").should eq("access")
    end

    it "should handle ZZES forms" do
      subject.pluralize("buzzes").should eq("buzz")
    end

    it "should pluralize regular S forms that done drop e" do
      subject.pluralize("becomes").should eq("become")
    end

    it "should pluralize regular S forms" do
      subject.pluralize("drinks").should eq("drink")
      subject.pluralize("claims").should eq("claim")
    end

    it "should pluralize irregular forms" do
      subject.pluralize("was").should eq("were")
      subject.pluralize("is").should eq("are")
      subject.pluralize("am").should eq("are")
      subject.pluralize("has").should eq("have")
    end

    it "should pluralize ies forms" do
      subject.pluralize("flies").should eq("fly")
      subject.pluralize("tries").should eq("try")
    end

    it "should handle ambiguous forms" do
      subject.pluralize("will").should eq("will")
    end
  end

  it "should pluralize and singularize string from patch" do
    "becomes".pluralize(false).should eq("become")
    "become".singularize(false).should eq("becomes")
  end
end
