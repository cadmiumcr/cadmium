require "../../spec_helper"

describe Cadmium::Phonetics::Metaphone do
  subject { described_class }

  it "should drop duplicate adjacent letters, except C" do
    expect(subject.dedup("dropping")).to eq("droping")
  end

  it "should not drop duplicat C" do
    expect(subject.dedup("accelerate")).to eq("accelerate")
  end

  it "should drop some initial letters" do
    expect(subject.drop_initial_letters("knuth")).to eq("nuth")
    expect(subject.drop_initial_letters("gnat")).to eq("nat")
    expect(subject.drop_initial_letters("aegis")).to eq("egis")
    expect(subject.drop_initial_letters("pneumatic")).to eq("neumatic")
    expect(subject.drop_initial_letters("wrack")).to eq("rack")
  end

  it "should not drop other initial letters" do
    expect(subject.drop_initial_letters("garbage")).to eq("garbage")
  end

  it "should b if if words end with mb" do
    expect(subject.drop_b_after_m_at_end("dumb")).to eq("dum")
  end

  it "should not drop b after m if not at end of word" do
    expect(subject.drop_b_after_m_at_end("dumbo")).to eq("dumbo")
  end

  it "should replace CH to X" do
    expect(subject.c_transform("change")).to eq("xhange")
  end

  it "should not replace CH to X if part of SCH" do
    expect(subject.c_transform("discharger")).to eq("diskharger")
  end

  it "should replace CIA to X" do
    expect(subject.c_transform("aesthetician")).to eq("aesthetixian")
  end

  it "C should become S if followed by I, E, or Y" do
    expect(subject.c_transform("cieling")).to eq("sieling")
  end

  it "should transform other C\"s to K" do
    expect(subject.c_transform("cuss")).to eq("kuss")
  end

  it "should transform D to J if followed by GE, GY, GI" do
    expect(subject.d_transform("abridge")).to eq("abrijge")
  end

  it "should transform D to T if not followed by GE, GY, GI" do
    expect(subject.d_transform("bid")).to eq("bit")
  end

  it "should drop G before H if not at the end or before vowell" do
    expect(subject.drop_g("alight")).to eq("aliht")
    expect(subject.drop_g("fright")).to eq("friht")
  end

  it "should drop G if followed by N or NED at the end" do
    expect(subject.drop_g("aligned")).to eq("alined")
    expect(subject.drop_g("align")).to eq("alin")
  end

  it "should transform G to J if followed by I, E or Y and not preceeded by G" do
    expect(subject.transform_g("age")).to eq("aje")
    expect(subject.transform_g("gin")).to eq("jin")
  end

  it "should transform G to K" do
    expect(subject.transform_g("august")).to eq("aukust")
  end

  it "should reduce GG to G before turning to K" do
    expect(subject.transform_g("aggrade")).to eq("akrade")
  end

  it "should drop H if after vowell and not before vowell" do
    expect(subject.drop_h("alriht")).to eq("alrit")
  end

  it "should not drop H if after vowell" do
    expect(subject.drop_h("that")).to eq("that")
  end

  it "should not drop H if not before vowell" do
    expect(subject.drop_h("chump")).to eq("chump")
  end

  it "should transform CK to K" do
    expect(subject.transform_ck("check")).to eq("chek")
  end

  it "should transform PH to F" do
    expect(subject.transform_ph("phone")).to eq("fone")
  end

  it "should transform Q to K" do
    expect(subject.transform_q("quack")).to eq("kuack")
  end

  it "should transform S to X if followed by H, IO, or IA" do
    expect(subject.transform_s("shack")).to eq("xhack")
    expect(subject.transform_s("sialagogues")).to eq("xialagogues")
    expect(subject.transform_s("asia")).to eq("axia")
  end

  it "should not transform S to X if not followed by H, IO, or IA" do
    expect(subject.transform_s("substance")).to eq("substance")
  end

  it "should transform T to X if followed by IA or IO" do
    expect(subject.transform_t("dementia")).to eq("demenxia")
    expect(subject.transform_t("abbreviation")).to eq("abbreviaxion")
  end

  it "should transform TH to 0" do
    expect(subject.transform_t("that")).to eq("0at")
  end

  it "should drop T if followed by CH" do
    expect(subject.drop_t("backstitch")).to eq("backstich")
  end

  it "should transform V to F" do
    expect(subject.transform_v("vestige")).to eq("festige")
  end

  it "should transform WH to W if at beginning" do
    expect(subject.transform_wh("whisper")).to eq("wisper")
  end

  it "should drop W if not followed by vowell" do
    expect(subject.drop_w("bowl")).to eq("bol")
    expect(subject.drop_w("warsaw")).to eq("warsa")
  end

  it "should transform X to S if at beginning" do
    expect(subject.transform_x("xenophile")).to eq("senophile")
  end

  it "should transform X to KS if not at beginning" do
    expect(subject.transform_x("admixed")).to eq("admiksed")
  end

  it "should drop Y of not followed by a vowell" do
    expect(subject.drop_y("analyzer")).to eq("analzer")
    expect(subject.drop_y("specify")).to eq("specif")
  end

  it "should not drop Y of followed by a vowell" do
    expect(subject.drop_y("allying")).to eq("allying")
  end

  it "should transform Z to S" do
    expect(subject.transform_z("blaze")).to eq("blase")
  end

  it "should drop all vowels except initial" do
    expect(subject.drop_vowels("ablaze")).to eq("ablz")
    expect(subject.drop_vowels("adamantium")).to eq("admntm")
  end

  it "should do all" do
    expect(subject.process("ablaze")).to eq("ABLS")
    expect(subject.process("transition")).to eq("TRNSXN")
    expect(subject.process("astronomical")).to eq("ASTRNMKL")
    expect(subject.process("buzzard")).to eq("BSRT")
    expect(subject.process("wonderer")).to eq("WNTRR")
    expect(subject.process("district")).to eq("TSTRKT")
    expect(subject.process("hockey")).to eq("HK")
    expect(subject.process("capital")).to eq("KPTL")
    expect(subject.process("penguin")).to eq("PNKN")
    expect(subject.process("garbonzo")).to eq("KRBNS")
    expect(subject.process("lightning")).to eq("LTNNK")
    expect(subject.process("light")).to eq("LT")
  end

  it "should compare strings" do
    expect(subject.compare("phonetics", "fonetix")).to be_true
    expect(subject.compare("phonetics", "garbonzo")).to be_false
    expect(subject.compare("PHONETICS", "fonetix")).to be_true
    expect(subject.compare("PHONETICS", "garbonzo")).to be_false
  end

  it "should compare strings with string patch" do
    expect("phonetics".sounds_like("fonetix")).to be_true
    expect("phonetics".sounds_like("garbonzo")).to be_false
    expect("PHONETICS".sounds_like("fonetix")).to be_true
    expect("PHONETICS".sounds_like("garbonzo")).to be_false
  end

  it "should return string phonetics with string patch" do
    expect("phonetics".phonetics).to eq("FNTKS")
    expect("PHONETICS".phonetics).to eq("FNTKS")
  end

  it "should transform PH to F #169" do
    expect("pharaoh".phonetics).to eq("FR")
    expect("tough".phonetics).to eq("TF")
  end

  it "should tokenize and return string phonetics with string patch" do
    expect("phonetics".tokenize_and_phoneticize).to eq(["FNTKS"])
    expect("phonetics garbonzo".tokenize_and_phoneticize).to eq(["FNTKS", "KRBNS"])
    expect("phonetics garbonzo lightning".tokenize_and_phoneticize).to eq(["FNTKS", "KRBNS", "LTNNK"])
  end

  it "should truncate to length specified if code exceeds" do
    expect(subject.process("phonetics", 4)).to eq("FNTK")
  end

  it "should not truncate to length specified if code does not exceed" do
    expect(subject.process("phonetics", 8)).to eq("FNTKS")
  end
end
