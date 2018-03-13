require "../../spec_helper"

describe Cadmium::Stemmers::PorterStemmer do
  subject { described_class }

  it "should categorize groups" do
    expect(subject.categorize_groups("syllog")).to eq("CVCVC")
    expect(subject.categorize_groups("gypsy")).to eq("CVCV")
  end

  it "should measure" do
    expect(subject.measure("syllog")).to eq(2)
  end

  it "should preform step 1a" do
    expect(subject.step1a("caresses")).to eq("caress")
    expect(subject.step1a("ponies")).to eq("poni")
    expect(subject.step1a("ties")).to eq("ti")
    expect(subject.step1a("caress")).to eq("caress")
    expect(subject.step1a("cats")).to eq("cat")
  end

  it "should perform step 1b" do
    expect(subject.step1b("feed")).to eq("feed")
    expect(subject.step1b("agreed")).to eq("agree")
    expect(subject.step1b("plastered")).to eq("plaster")
    expect(subject.step1b("bled")).to eq("bled")
    expect(subject.step1b("motoring")).to eq("motor")
    expect(subject.step1b("sing")).to eq("sing")
  end

  it "should perform step 1c" do
    expect(subject.step1c("happy")).to eq("happi")
    expect(subject.step1c("sky")).to eq("sky")
  end

  it "should perform step 2" do
    expect(subject.step2("relational")).to eq("relate")
    expect(subject.step2("conditional")).to eq("condition")
    expect(subject.step2("rational")).to eq("rational")
    expect(subject.step2("valenci")).to eq("valence")
    expect(subject.step2("hesitanci")).to eq("hesitance")
    expect(subject.step2("digitizer")).to eq("digitize")
    expect(subject.step2("conformabli")).to eq("conformable")
    expect(subject.step2("radicalli")).to eq("radical")
    expect(subject.step2("differentli")).to eq("different")
    expect(subject.step2("vileli")).to eq("vile")
    expect(subject.step2("analogousli")).to eq("analogous")
    expect(subject.step2("vietnamization")).to eq("vietnamize")
    expect(subject.step2("predication")).to eq("predicate")
    expect(subject.step2("operator")).to eq("operate")
    expect(subject.step2("feudalism")).to eq("feudal")
    expect(subject.step2("decisiveness")).to eq("decisive")
    expect(subject.step2("hopefulness")).to eq("hopeful")
    expect(subject.step2("callousness")).to eq("callous")
    expect(subject.step2("formaliti")).to eq("formal")
    expect(subject.step2("sensitiviti")).to eq("sensitive")
    expect(subject.step2("sensibiliti")).to eq("sensible")
  end

  it "should preform step 3" do
    expect(subject.step3("triplicate")).to eq("triplic")
    expect(subject.step3("formative")).to eq("form")
    expect(subject.step3("formalize")).to eq("formal")
    expect(subject.step3("electriciti")).to eq("electric")
    expect(subject.step3("electrical")).to eq("electric")
    expect(subject.step3("hopeful")).to eq("hope")
    expect(subject.step3("goodness")).to eq("good")
  end

  it "should perform step 4" do
    expect(subject.step4("revival")).to eq("reviv")
    expect(subject.step4("allowance")).to eq("allow")
    expect(subject.step4("inference")).to eq("infer")
    expect(subject.step4("airliner")).to eq("airlin")
    expect(subject.step4("gyroscopic")).to eq("gyroscop")
    expect(subject.step4("adjustable")).to eq("adjust")
    expect(subject.step4("defensible")).to eq("defens")
    expect(subject.step4("irritant")).to eq("irrit")
    expect(subject.step4("replacement")).to eq("replac")
    expect(subject.step4("adjustment")).to eq("adjust")
    expect(subject.step4("dependent")).to eq("depend")
    expect(subject.step4("adoption")).to eq("adopt")
    expect(subject.step4("homologou")).to eq("homolog")
    expect(subject.step4("communism")).to eq("commun")
    expect(subject.step4("activate")).to eq("activ")
    expect(subject.step4("angulariti")).to eq("angular")
    expect(subject.step4("homologous")).to eq("homolog")
    expect(subject.step4("effective")).to eq("effect")
    expect(subject.step4("bowdlerize")).to eq("bowdler")
  end

  it "should perform step 5a" do
    expect(subject.step5a("probate")).to eq("probat")
    expect(subject.step5a("rate")).to eq("rate")
    expect(subject.step5a("cease")).to eq("ceas")
  end

  it "should preform step 5b" do
    expect(subject.step5b("controll")).to eq("control")
    expect(subject.step5b("roll")).to eq("roll")
  end

  it "should preform complete stemming" do
    expect(subject.stem("scoring")).to eq("score")
    expect(subject.stem("scored")).to eq("score")
    expect(subject.stem("scores")).to eq("score")
    expect(subject.stem("score")).to eq("score")
    expect(subject.stem("SCORING")).to eq("score")
    expect(subject.stem("SCORED")).to eq("score")
    expect(subject.stem("SCORES")).to eq("score")
    expect(subject.stem("SCORE")).to eq("score")
    expect(subject.stem("nationals")).to eq("nation")
    expect(subject.stem("doing")).to eq("do")
  end

  it "should perform animated to anim" do
    expect(subject.stem("animated")).to eq("anim")
  end

  it "should tokenize and stem with String#tokenize_and_stem" do
    expect("scoring stinks".tokenize_and_stem).to eq(["score", "stink"])
    expect("SCORING STINKS".tokenize_and_stem).to eq(["score", "stink"])
  end

  it "should tokenize and stem ignoring stop words" do
    expect("My dog is very fun TO play with And another thing, he is A poodle.".tokenize_and_stem).to eq(["dog", "fun", "plai", "thing", "poodl"])
  end

  it "should tokenize and stem including stopwords" do
    expect("My dog is very fun TO play with And another thing, he is A poodle.".tokenize_and_stem(keep_stops: true)).to eq(["my", "dog", "is", "veri", "fun", "to", "plai", "with", "and", "anoth", "thing", "he", "is", "a", "poodl"])
  end
end
