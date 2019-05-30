require "../../spec_helper"

describe Cadmium::NounInflector do
  subject = Cadmium::NounInflector.new

  describe "#singularize" do
    it "should drop an S by default" do
      subject.singularize("rrrs").should eq("rrr")
      subject.singularize("hackers").should eq("hacker")
      subject.singularize("movies").should eq("movie")

      # MAN cases that don"t pluralize to MEN
      subject.singularize("talismans").should eq("talisman")
      subject.singularize("humans").should eq("human")
      subject.singularize("prehumans").should eq("prehuman")
    end

    it "should handle ambiguous form" do
      subject.singularize("deer").should eq("deer")
      subject.singularize("fish").should eq("fish")
      subject.singularize("series").should eq("series")
      subject.singularize("sheep").should eq("sheep")
      subject.singularize("trout").should eq("trout")
    end

    it "should convert plurals endind in SES to S" do
      subject.singularize("statuses").should eq("status")
      subject.singularize("buses").should eq("bus")
    end

    it "should match irregulars" do
      subject.singularize("people").should eq("person")
      subject.singularize("children").should eq("child")
      subject.singularize("oxen").should eq("ox")
      subject.singularize("clothes").should eq("cloth")
      subject.singularize("heroes").should eq("hero")
    end

    it "should handle IX cases" do
      subject.singularize("matrices").should eq("matrix")
      subject.singularize("indices").should eq("index")
      subject.singularize("cortices").should eq("cortex")
    end

    it "should handle ES cases" do
      subject.singularize("churches").should eq("church")
      subject.singularize("appendixes").should eq("appendix")
      subject.singularize("messes").should eq("mess")
      subject.singularize("quizes").should eq("quiz")
      subject.singularize("shoes").should eq("shoe")
      subject.singularize("funguses").should eq("fungus")
    end

    it "should handle special OES cases" do
      subject.singularize("tomatoes").should eq("tomato")
    end

    it "should handle I cases" do
      subject.singularize("octopi").should eq("octopus")
      subject.singularize("stimuli").should eq("stimulus")
      subject.singularize("radii").should eq("radius")
      subject.singularize("nuclei").should eq("nucleus")
      subject.singularize("fungi").should eq("fungus")
      subject.singularize("cacti").should eq("cactus")
    end

    it "should handle IVES cases" do
      subject.singularize("lives").should eq("life")
      subject.singularize("knives").should eq("knife")
    end

    it "should handle Y cases" do
      subject.singularize("parties").should eq("party")
      subject.singularize("flies").should eq("fly")
      subject.singularize("victories").should eq("victory")
      subject.singularize("monstrosities").should eq("monstrosity")
    end

    it "should handle SS cases" do
      subject.singularize("dresses").should eq("dress")
      subject.singularize("dress").should eq("dress")
      subject.singularize("messes").should eq("mess")
    end

    it "should handle MAN->MAN cases" do
      subject.singularize("men").should eq("man")
      subject.singularize("women").should eq("woman")
      subject.singularize("workmen").should eq("workman")
      subject.singularize("riflemen").should eq("rifleman")
    end

    it "should handle irregular cases" do
      subject.singularize("feet").should eq("foot")
      subject.singularize("geese").should eq("goose")
      subject.singularize("teeth").should eq("tooth")
      subject.singularize("ephemerides").should eq("ephemeris")
    end

    it "should handle AE cases" do
      subject.singularize("antennae").should eq("antenna")
      subject.singularize("formulae").should eq("formula")
      subject.singularize("nebulae").should eq("nebula")
      subject.singularize("vertebrae").should eq("vertebra")
      subject.singularize("vitae").should eq("vita")
    end

    it "should allow AE cases to be S" do
      subject.singularize("antennas").should eq("antenna")
      subject.singularize("formulas").should eq("formula")
    end
  end

  describe "#pluralize" do
    it "should append an S by default" do
      subject.pluralize("rrr").should eq("rrrs")
      subject.pluralize("hacker").should eq("hackers")
      subject.pluralize("movie").should eq("movies")
    end

    it "should handle ambiguous form" do
      subject.pluralize("deer").should eq("deer")
      subject.pluralize("fish").should eq("fish")
      subject.pluralize("series").should eq("series")
      subject.pluralize("sheep").should eq("sheep")
      subject.pluralize("trout").should eq("trout")
    end

    it "should convert singulars ending s to ses" do
      subject.pluralize("status").should eq("statuses")
      subject.pluralize("bus").should eq("buses")
    end

    it "should match irregulars" do
      subject.pluralize("person").should eq("people")
      subject.pluralize("child").should eq("children")
      subject.pluralize("ox").should eq("oxen")
    end

    it "should maintain case of irregulars" do
      subject.pluralize("OX").should eq("OXEN")
      subject.pluralize("Person").should eq("People")
      subject.pluralize("child").should eq("children")
      subject.pluralize("cloth").should eq("clothes")
    end

    it "should handle IX cases" do
      subject.pluralize("matrix").should eq("matrices")
      subject.pluralize("index").should eq("indices")
      subject.pluralize("cortex").should eq("cortices")
    end

    it "should regulars to ES" do
      subject.pluralize("church").should eq("churches")
      subject.pluralize("appendix").should eq("appendixes")
      subject.pluralize("mess").should eq("messes")
      subject.pluralize("quiz").should eq("quizes")
      subject.pluralize("shoe").should eq("shoes")
    end

    it "should handle SIS cases" do
      subject.pluralize("synopsis").should eq("synopses")
      subject.pluralize("parenthesis").should eq("parentheses")
    end

    it "should handle special OES cases" do
      subject.pluralize("tomato").should eq("tomatoes")
      subject.pluralize("buffalo").should eq("buffaloes")
      subject.pluralize("tornado").should eq("tornadoes")
    end

    it "should handle I cases" do
      subject.pluralize("radius").should eq("radii")
      subject.pluralize("octopus").should eq("octopi")
      subject.pluralize("stimulus").should eq("stimuli")
      subject.pluralize("nucleus").should eq("nuclei")
      subject.pluralize("fungus").should eq("fungi")
      subject.pluralize("cactus").should eq("cacti")
    end

    it "should handle IVES cases" do
      subject.pluralize("knife").should eq("knives")
      subject.pluralize("life").should eq("lives")
    end

    it "should handle Y cases" do
      subject.pluralize("party").should eq("parties")
      subject.pluralize("fly").should eq("flies")
      subject.pluralize("victory").should eq("victories")
      subject.pluralize("monstrosity").should eq("monstrosities")
    end

    it "should handle SS cases" do
      subject.pluralize("dress").should eq("dresses")
      subject.pluralize("dresses").should eq("dresses")
      subject.pluralize("mess").should eq("messes")
    end

    it "should handle MAN->MEN cases" do
      subject.pluralize("man").should eq("men")
      subject.pluralize("woman").should eq("women")
      subject.pluralize("workman").should eq("workmen")
      subject.pluralize("rifleman").should eq("riflemen")
    end

    it "should handle irregular cases" do
      subject.pluralize("foot").should eq("feet")
      subject.pluralize("goose").should eq("geese")
      subject.pluralize("tooth").should eq("teeth")
      subject.pluralize("ephemeris").should eq("ephemerides")

      subject.pluralize("talisman").should eq("talismans")
      subject.pluralize("human").should eq("humans")
      subject.pluralize("prehuman").should eq("prehumans")
    end

    it "should handle AE cases" do
      subject.pluralize("antenna").should eq("antennae")
      subject.pluralize("formula").should eq("formulae")
      subject.pluralize("nebula").should eq("nebulae")
      subject.pluralize("vertebra").should eq("vertebrae")
      subject.pluralize("vita").should eq("vitae")
    end
  end
end
