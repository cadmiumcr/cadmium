require "../../spec_helper"

describe Cadmium::Inflectors::NounInflector do
  subject { described_class.new }

  describe "#singularize" do
    it "should drop an S by default" do
      expect(subject.singularize("rrrs")).to eq("rrr")
      expect(subject.singularize("hackers")).to eq("hacker")
      expect(subject.singularize("movies")).to eq("movie")

      # MAN cases that don"t pluralize to MEN
      expect(subject.singularize("talismans")).to eq("talisman")
      expect(subject.singularize("humans")).to eq("human")
      expect(subject.singularize("prehumans")).to eq("prehuman")
    end

    it "should handle ambiguous form" do
      expect(subject.singularize("deer")).to eq("deer")
      expect(subject.singularize("fish")).to eq("fish")
      expect(subject.singularize("series")).to eq("series")
      expect(subject.singularize("sheep")).to eq("sheep")
      expect(subject.singularize("trout")).to eq("trout")
    end

    it "should convert plurals endind in SES to S" do
      expect(subject.singularize("statuses")).to eq("status")
      expect(subject.singularize("buses")).to eq("bus")
    end

    it "should match irregulars" do
      expect(subject.singularize("people")).to eq("person")
      expect(subject.singularize("children")).to eq("child")
      expect(subject.singularize("oxen")).to eq("ox")
      expect(subject.singularize("clothes")).to eq("cloth")
      expect(subject.singularize("heroes")).to eq("hero")
    end

    it "should handle IX cases" do
      expect(subject.singularize("matrices")).to eq("matrix")
      expect(subject.singularize("indices")).to eq("index")
      expect(subject.singularize("cortices")).to eq("cortex")
    end

    it "should handle ES cases" do
      expect(subject.singularize("churches")).to eq("church")
      expect(subject.singularize("appendixes")).to eq("appendix")
      expect(subject.singularize("messes")).to eq("mess")
      expect(subject.singularize("quizes")).to eq("quiz")
      expect(subject.singularize("shoes")).to eq("shoe")
      expect(subject.singularize("funguses")).to eq("fungus")
    end

    it "should handle special OES cases" do
      expect(subject.singularize("tomatoes")).to eq("tomato")
    end

    it "should handle I cases" do
      expect(subject.singularize("octopi")).to eq("octopus")
      expect(subject.singularize("stimuli")).to eq("stimulus")
      expect(subject.singularize("radii")).to eq("radius")
      expect(subject.singularize("nuclei")).to eq("nucleus")
      expect(subject.singularize("fungi")).to eq("fungus")
      expect(subject.singularize("cacti")).to eq("cactus")
    end

    it "should handle IVES cases" do
      expect(subject.singularize("lives")).to eq("life")
      expect(subject.singularize("knives")).to eq("knife")
    end

    it "should handle Y cases" do
      expect(subject.singularize("parties")).to eq("party")
      expect(subject.singularize("flies")).to eq("fly")
      expect(subject.singularize("victories")).to eq("victory")
      expect(subject.singularize("monstrosities")).to eq("monstrosity")
    end

    it "should handle SS cases" do
      expect(subject.singularize("dresses")).to eq("dress")
      expect(subject.singularize("dress")).to eq("dress")
      expect(subject.singularize("messes")).to eq("mess")
    end

    it "should handle MAN->MAN cases" do
      expect(subject.singularize("men")).to eq("man")
      expect(subject.singularize("women")).to eq("woman")
      expect(subject.singularize("workmen")).to eq("workman")
      expect(subject.singularize("riflemen")).to eq("rifleman")
    end

    it "should handle irregular cases" do
      expect(subject.singularize("feet")).to eq("foot")
      expect(subject.singularize("geese")).to eq("goose")
      expect(subject.singularize("teeth")).to eq("tooth")
      expect(subject.singularize("ephemerides")).to eq("ephemeris")
    end

    it "should handle AE cases" do
      expect(subject.singularize("antennae")).to eq("antenna")
      expect(subject.singularize("formulae")).to eq("formula")
      expect(subject.singularize("nebulae")).to eq("nebula")
      expect(subject.singularize("vertebrae")).to eq("vertebra")
      expect(subject.singularize("vitae")).to eq("vita")
    end

    it "should allow AE cases to be S" do
      expect(subject.singularize("antennas")).to eq("antenna")
      expect(subject.singularize("formulas")).to eq("formula")
    end
  end

  describe "#pluralize" do
    it "should append an S by default" do
      expect(subject.pluralize("rrr")).to eq("rrrs")
      expect(subject.pluralize("hacker")).to eq("hackers")
      expect(subject.pluralize("movie")).to eq("movies")
    end

    it "should handle ambiguous form" do
      expect(subject.pluralize("deer")).to eq("deer")
      expect(subject.pluralize("fish")).to eq("fish")
      expect(subject.pluralize("series")).to eq("series")
      expect(subject.pluralize("sheep")).to eq("sheep")
      expect(subject.pluralize("trout")).to eq("trout")
    end

    it "should convert singulars ending s to ses" do
      expect(subject.pluralize("status")).to eq("statuses")
      expect(subject.pluralize("bus")).to eq("buses")
    end

    it "should match irregulars" do
      expect(subject.pluralize("person")).to eq("people")
      expect(subject.pluralize("child")).to eq("children")
      expect(subject.pluralize("ox")).to eq("oxen")
    end

    it "should maintain case of irregulars" do
      expect(subject.pluralize("OX")).to eq("OXEN")
      expect(subject.pluralize("Person")).to eq("People")
      expect(subject.pluralize("child")).to eq("children")
      expect(subject.pluralize("cloth")).to eq("clothes")
    end

    it "should handle IX cases" do
      expect(subject.pluralize("matrix")).to eq("matrices")
      expect(subject.pluralize("index")).to eq("indices")
      expect(subject.pluralize("cortex")).to eq("cortices")
    end

    it "should regulars to ES" do
      expect(subject.pluralize("church")).to eq("churches")
      expect(subject.pluralize("appendix")).to eq("appendixes")
      expect(subject.pluralize("mess")).to eq("messes")
      expect(subject.pluralize("quiz")).to eq("quizes")
      expect(subject.pluralize("shoe")).to eq("shoes")
    end

    it "should handle SIS cases" do
      expect(subject.pluralize("synopsis")).to eq("synopses")
      expect(subject.pluralize("parenthesis")).to eq("parentheses")
    end

    it "should handle special OES cases" do
      expect(subject.pluralize("tomato")).to eq("tomatoes")
      expect(subject.pluralize("buffalo")).to eq("buffaloes")
      expect(subject.pluralize("tornado")).to eq("tornadoes")
    end

    it "should handle I cases" do
      expect(subject.pluralize("radius")).to eq("radii")
      expect(subject.pluralize("octopus")).to eq("octopi")
      expect(subject.pluralize("stimulus")).to eq("stimuli")
      expect(subject.pluralize("nucleus")).to eq("nuclei")
      expect(subject.pluralize("fungus")).to eq("fungi")
      expect(subject.pluralize("cactus")).to eq("cacti")
    end

    it "should handle IVES cases" do
      expect(subject.pluralize("knife")).to eq("knives")
      expect(subject.pluralize("life")).to eq("lives")
    end

    it "should handle Y cases" do
      expect(subject.pluralize("party")).to eq("parties")
      expect(subject.pluralize("fly")).to eq("flies")
      expect(subject.pluralize("victory")).to eq("victories")
      expect(subject.pluralize("monstrosity")).to eq("monstrosities")
    end

    it "should handle SS cases" do
      expect(subject.pluralize("dress")).to eq("dresses")
      expect(subject.pluralize("dresses")).to eq("dresses")
      expect(subject.pluralize("mess")).to eq("messes")
    end

    it "should handle MAN->MEN cases" do
      expect(subject.pluralize("man")).to eq("men")
      expect(subject.pluralize("woman")).to eq("women")
      expect(subject.pluralize("workman")).to eq("workmen")
      expect(subject.pluralize("rifleman")).to eq("riflemen")
    end

    it "should handle irregular cases" do
      expect(subject.pluralize("foot")).to eq("feet")
      expect(subject.pluralize("goose")).to eq("geese")
      expect(subject.pluralize("tooth")).to eq("teeth")
      expect(subject.pluralize("ephemeris")).to eq("ephemerides")

      expect(subject.pluralize("talisman")).to eq("talismans")
      expect(subject.pluralize("human")).to eq("humans")
      expect(subject.pluralize("prehuman")).to eq("prehumans")
    end

    it "should handle AE cases" do
      expect(subject.pluralize("antenna")).to eq("antennae")
      expect(subject.pluralize("formula")).to eq("formulae")
      expect(subject.pluralize("nebula")).to eq("nebulae")
      expect(subject.pluralize("vertebra")).to eq("vertebrae")
      expect(subject.pluralize("vita")).to eq("vitae")
    end
  end
end
