require "../../spec_helper"

describe Cadmium::Metaphone do
  subject = Cadmium::Metaphone

  it "should drop duplicate adjacent letters, except C" do
    subject.dedup("dropping").should eq("droping")
  end

  it "should not drop duplicat C" do
    subject.dedup("accelerate").should eq("accelerate")
  end

  it "should drop some initial letters" do
    subject.drop_initial_letters("knuth").should eq("nuth")
    subject.drop_initial_letters("gnat").should eq("nat")
    subject.drop_initial_letters("aegis").should eq("egis")
    subject.drop_initial_letters("pneumatic").should eq("neumatic")
    subject.drop_initial_letters("wrack").should eq("rack")
  end

  it "should not drop other initial letters" do
    subject.drop_initial_letters("garbage").should eq("garbage")
  end

  it "should b if if words end with mb" do
    subject.drop_b_after_m_at_end("dumb").should eq("dum")
  end

  it "should not drop b after m if not at end of word" do
    subject.drop_b_after_m_at_end("dumbo").should eq("dumbo")
  end

  it "should replace CH to X" do
    subject.c_transform("change").should eq("xhange")
  end

  it "should not replace CH to X if part of SCH" do
    subject.c_transform("discharger").should eq("diskharger")
  end

  it "should replace CIA to X" do
    subject.c_transform("aesthetician").should eq("aesthetixian")
  end

  it "C should become S if followed by I, E, or Y" do
    subject.c_transform("cieling").should eq("sieling")
  end

  it "should transform other C\"s to K" do
    subject.c_transform("cuss").should eq("kuss")
  end

  it "should transform D to J if followed by GE, GY, GI" do
    subject.d_transform("abridge").should eq("abrijge")
  end

  it "should transform D to T if not followed by GE, GY, GI" do
    subject.d_transform("bid").should eq("bit")
  end

  it "should drop G before H if not at the end or before vowell" do
    subject.drop_g("alight").should eq("aliht")
    subject.drop_g("fright").should eq("friht")
  end

  it "should drop G if followed by N or NED at the end" do
    subject.drop_g("aligned").should eq("alined")
    subject.drop_g("align").should eq("alin")
  end

  it "should transform G to J if followed by I, E or Y and not preceeded by G" do
    subject.transform_g("age").should eq("aje")
    subject.transform_g("gin").should eq("jin")
  end

  it "should transform G to K" do
    subject.transform_g("august").should eq("aukust")
  end

  it "should reduce GG to G before turning to K" do
    subject.transform_g("aggrade").should eq("akrade")
  end

  it "should drop H if after vowell and not before vowell" do
    subject.drop_h("alriht").should eq("alrit")
  end

  it "should not drop H if after vowell" do
    subject.drop_h("that").should eq("that")
  end

  it "should not drop H if not before vowell" do
    subject.drop_h("chump").should eq("chump")
  end

  it "should transform CK to K" do
    subject.transform_ck("check").should eq("chek")
  end

  it "should transform PH to F" do
    subject.transform_ph("phone").should eq("fone")
  end

  it "should transform Q to K" do
    subject.transform_q("quack").should eq("kuack")
  end

  it "should transform S to X if followed by H, IO, or IA" do
    subject.transform_s("shack").should eq("xhack")
    subject.transform_s("sialagogues").should eq("xialagogues")
    subject.transform_s("asia").should eq("axia")
  end

  it "should not transform S to X if not followed by H, IO, or IA" do
    subject.transform_s("substance").should eq("substance")
  end

  it "should transform T to X if followed by IA or IO" do
    subject.transform_t("dementia").should eq("demenxia")
    subject.transform_t("abbreviation").should eq("abbreviaxion")
  end

  it "should transform TH to 0" do
    subject.transform_t("that").should eq("0at")
  end

  it "should drop T if followed by CH" do
    subject.drop_t("backstitch").should eq("backstich")
  end

  it "should transform V to F" do
    subject.transform_v("vestige").should eq("festige")
  end

  it "should transform WH to W if at beginning" do
    subject.transform_wh("whisper").should eq("wisper")
  end

  it "should drop W if not followed by vowell" do
    subject.drop_w("bowl").should eq("bol")
    subject.drop_w("warsaw").should eq("warsa")
  end

  it "should transform X to S if at beginning" do
    subject.transform_x("xenophile").should eq("senophile")
  end

  it "should transform X to KS if not at beginning" do
    subject.transform_x("admixed").should eq("admiksed")
  end

  it "should drop Y of not followed by a vowell" do
    subject.drop_y("analyzer").should eq("analzer")
    subject.drop_y("specify").should eq("specif")
  end

  it "should not drop Y of followed by a vowell" do
    subject.drop_y("allying").should eq("allying")
  end

  it "should transform Z to S" do
    subject.transform_z("blaze").should eq("blase")
  end

  it "should drop all vowels except initial" do
    subject.drop_vowels("ablaze").should eq("ablz")
    subject.drop_vowels("adamantium").should eq("admntm")
  end

  it "should do all" do
    subject.process("ablaze").should eq("ABLS")
    subject.process("transition").should eq("TRNSXN")
    subject.process("astronomical").should eq("ASTRNMKL")
    subject.process("buzzard").should eq("BSRT")
    subject.process("wonderer").should eq("WNTRR")
    subject.process("district").should eq("TSTRKT")
    subject.process("hockey").should eq("HK")
    subject.process("capital").should eq("KPTL")
    subject.process("penguin").should eq("PNKN")
    subject.process("garbonzo").should eq("KRBNS")
    subject.process("lightning").should eq("LTNNK")
    subject.process("light").should eq("LT")
  end

  it "should compare strings" do
    subject.compare("phonetics", "fonetix").should be_true
    subject.compare("phonetics", "garbonzo").should be_false
    subject.compare("PHONETICS", "fonetix").should be_true
    subject.compare("PHONETICS", "garbonzo").should be_false
  end

  it "should compare strings with string patch" do
    "phonetics".sounds_like("fonetix").should be_true
    "phonetics".sounds_like("garbonzo").should be_false
    "PHONETICS".sounds_like("fonetix").should be_true
    "PHONETICS".sounds_like("garbonzo").should be_false
  end

  it "should return string phonetics with string patch" do
    "phonetics".phonetics.should eq("FNTKS")
    "PHONETICS".phonetics.should eq("FNTKS")
  end

  it "should transform PH to F #169" do
    "pharaoh".phonetics.should eq("FR")
    "tough".phonetics.should eq("TF")
  end

  it "should tokenize and return string phonetics with string patch" do
    "phonetics".tokenize_and_phoneticize.should eq(["FNTKS"])
    "phonetics garbonzo".tokenize_and_phoneticize.should eq(["FNTKS", "KRBNS"])
    "phonetics garbonzo lightning".tokenize_and_phoneticize.should eq(["FNTKS", "KRBNS", "LTNNK"])
  end

  it "should truncate to length specified if code exceeds" do
    subject.process("phonetics", 4).should eq("FNTK")
  end

  it "should not truncate to length specified if code does not exceed" do
    subject.process("phonetics", 8).should eq("FNTKS")
  end
end
