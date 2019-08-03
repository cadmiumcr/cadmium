require "../../spec_helper"

describe Cadmium::PorterStemmer do
  subject = Cadmium::PorterStemmer

  it "should categorize groups" do
    subject.categorize_groups("syllog").should eq("CVCVC")
    subject.categorize_groups("gypsy").should eq("CVCV")
  end

  it "should measure" do
    subject.measure("syllog").should eq(2)
  end

  it "should preform step 1a" do
    subject.step1a("caresses").should eq("caress")
    subject.step1a("ponies").should eq("poni")
    subject.step1a("ties").should eq("ti")
    subject.step1a("caress").should eq("caress")
    subject.step1a("cats").should eq("cat")
  end

  it "should perform step 1b" do
    subject.step1b("feed").should eq("feed")
    subject.step1b("agreed").should eq("agree")
    subject.step1b("plastered").should eq("plaster")
    subject.step1b("bled").should eq("bled")
    subject.step1b("motoring").should eq("motor")
    subject.step1b("sing").should eq("sing")
  end

  it "should perform step 1c" do
    subject.step1c("happy").should eq("happi")
    subject.step1c("sky").should eq("sky")
  end

  it "should perform step 2" do
    subject.step2("relational").should eq("relate")
    subject.step2("conditional").should eq("condition")
    subject.step2("rational").should eq("rational")
    subject.step2("valenci").should eq("valence")
    subject.step2("hesitanci").should eq("hesitance")
    subject.step2("digitizer").should eq("digitize")
    subject.step2("conformabli").should eq("conformable")
    subject.step2("radicalli").should eq("radical")
    subject.step2("differentli").should eq("different")
    subject.step2("vileli").should eq("vile")
    subject.step2("analogousli").should eq("analogous")
    subject.step2("vietnamization").should eq("vietnamize")
    subject.step2("predication").should eq("predicate")
    subject.step2("operator").should eq("operate")
    subject.step2("feudalism").should eq("feudal")
    subject.step2("decisiveness").should eq("decisive")
    subject.step2("hopefulness").should eq("hopeful")
    subject.step2("callousness").should eq("callous")
    subject.step2("formaliti").should eq("formal")
    subject.step2("sensitiviti").should eq("sensitive")
    subject.step2("sensibiliti").should eq("sensible")
  end

  it "should preform step 3" do
    subject.step3("triplicate").should eq("triplic")
    subject.step3("formative").should eq("form")
    subject.step3("formalize").should eq("formal")
    subject.step3("electriciti").should eq("electric")
    subject.step3("electrical").should eq("electric")
    subject.step3("hopeful").should eq("hope")
    subject.step3("goodness").should eq("good")
  end

  it "should perform step 4" do
    subject.step4("revival").should eq("reviv")
    subject.step4("allowance").should eq("allow")
    subject.step4("inference").should eq("infer")
    subject.step4("airliner").should eq("airlin")
    subject.step4("gyroscopic").should eq("gyroscop")
    subject.step4("adjustable").should eq("adjust")
    subject.step4("defensible").should eq("defens")
    subject.step4("irritant").should eq("irrit")
    subject.step4("replacement").should eq("replac")
    subject.step4("adjustment").should eq("adjust")
    subject.step4("dependent").should eq("depend")
    subject.step4("adoption").should eq("adopt")
    subject.step4("homologou").should eq("homolog")
    subject.step4("communism").should eq("commun")
    subject.step4("activate").should eq("activ")
    subject.step4("angulariti").should eq("angular")
    subject.step4("homologous").should eq("homolog")
    subject.step4("effective").should eq("effect")
    subject.step4("bowdlerize").should eq("bowdler")
  end

  it "should perform step 5a" do
    subject.step5a("probate").should eq("probat")
    subject.step5a("rate").should eq("rate")
    subject.step5a("cease").should eq("ceas")
  end

  it "should preform step 5b" do
    subject.step5b("controll").should eq("control")
    subject.step5b("roll").should eq("roll")
  end

  it "should preform complete stemming" do
    subject.stem("scoring").should eq("score")
    subject.stem("scored").should eq("score")
    subject.stem("scores").should eq("score")
    subject.stem("score").should eq("score")
    subject.stem("SCORING").should eq("score")
    subject.stem("SCORED").should eq("score")
    subject.stem("SCORES").should eq("score")
    subject.stem("SCORE").should eq("score")
    subject.stem("nationals").should eq("nation")
    subject.stem("doing").should eq("do")
  end

  it "should perform animated to anim" do
    subject.stem("animated").should eq("anim")
  end

  it "should tokenize and stem with String#tokenize_and_stem" do
    "scoring stinks".tokenize_and_stem.should eq(["score", "stink"])
    "SCORING STINKS".tokenize_and_stem.should eq(["score", "stink"])
  end

  it "should tokenize and stem ignoring stop words" do
    "My dog is very fun TO play with And another thing, he is A poodle.".tokenize_and_stem.should eq(["dog", "fun", "plai", "poodl"])
  end

  it "should tokenize and stem including stopwords" do
    "My dog is very fun TO play with And another thing, he is A poodle.".tokenize_and_stem(keep_stops: true).should eq(["my", "dog", "is", "veri", "fun", "to", "plai", "with", "and", "anoth", "thing", "he", "is", "a", "poodl"])
  end
end
