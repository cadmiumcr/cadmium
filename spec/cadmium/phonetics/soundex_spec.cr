require "../../spec_helper"

describe Cadmium::SoundEx do
  subject = Cadmium::SoundEx

  describe ".transform_lips" do
    it "should replace B, F, P, and V with 1" do
      subject.transform_lips("bopper").should eq("1o11er")
      subject.transform_lips("valumf").should eq("1alum1")
    end
  end

  describe ".transform_throats" do
    it "should replace C, G, J, K, Q, S, X, Z with 2" do
      subject.transform_throats("cagjjkiqsxz").should eq("2a2222i2222")
    end
  end

  describe ".transform_tongue" do
    it "should replace D and T with 3" do
      subject.transform_tongue("dat").should eq("3a3")
    end
  end

  describe "transform_l" do
    it "should replace L with 4" do
      subject.transform_l("lala").should eq("4a4a")
    end
  end

  describe "transform_hum" do
    it "should replace M and N with 5" do
      subject.transform_hum("mummification").should eq("5u55ificatio5")
    end
  end

  describe "transform_r" do
    it "should replace R with 6" do
      subject.transform_r("render").should eq("6ende6")
    end
  end

  describe "condense" do
    it "sound condense sequences" do
      subject.condense("11222556").should eq("1256")
    end
  end

  describe "pad_right_0" do
    it "sound padd zeros on the right to a lenght of 3" do
      subject.pad_right_0("1").should eq("100")
      subject.pad_right_0("11").should eq("110")
      subject.pad_right_0("111").should eq("111")
    end
  end

  it "should not code the first character" do
    subject.process("render")[0].should eq('R')
  end

  it "should pad right with zeros" do
    subject.process("super").should eq("S160")
    subject.process("butt").should eq("B300")
    subject.process("a").should eq("A000") # Causing an error
  end

  it "should pad right with zeros" do
    subject.process("but").should eq("B300")
  end

  it "should perform soundex" do
    subject.process("BLACKBERRY").should eq("B421") # TODO: Make sure this is right
    subject.process("blackberry").should eq("B421")
    subject.process("calculate").should eq("C424")
    subject.process("CALCULATE").should eq("C424")
    subject.process("fox").should eq("F200")
    subject.process("FOX").should eq("F200")
    subject.process("jump").should eq("J510")
    subject.process("JUMP").should eq("J510")
    subject.process("phonetics").should eq("P532")
    subject.process("PHONETICS").should eq("P532")
  end

  it "should perform soundex via compare method" do
    subject.compare("ant", "and").should be_true
    subject.compare("ant", "anne").should be_false
    subject.compare("band", "bant").should be_true
    subject.compare("band", "gand").should be_false
  end

  it "should perform soundex via attached sounds_like String patch" do
    "ant".sounds_like("ant", subject).should be_true
    "ant".sounds_like("anne", subject).should be_false
    "band".sounds_like("bant", subject).should be_true
    "band".sounds_like("gand", subject).should be_false
  end

  it "should return string phonetics with string patch" do
    "phonetics".phonetics(nil, subject).should eq("P532")
    "PHONETICS".phonetics(nil, subject).should eq("P532")
  end

  it "issue 221 -- inital vowels that duplicate cons codes" do
    "Lloyd".phonetics(nil, subject).should eq("L300")
    "Pfister".phonetics(nil, subject).should eq("P236")

    "manhattan".phonetics(nil, subject).should eq("M535")
    "Lukasiewicz".phonetics(nil, subject).should eq("L222")

    "Gauss".phonetics(nil, subject).should eq("G200")
    "Tymczak".phonetics(nil, subject).should eq("T522")
    "Jackson".phonetics(nil, subject).should eq("J250")
  end

  it "should tokenize and return string phonetics with string patch" do
    "phonetics".tokenize_and_phoneticize(false, subject).should eq(["P532"])
    "phonetics jump".tokenize_and_phoneticize(false, subject).should eq(["P532", "J510"])
    "phonetics jump calculate".tokenize_and_phoneticize(false, subject).should eq(["P532", "J510", "C424"])
  end

  it "should max out at four characters long by default" do
    subject.process("supercalifragilisticexpialidocious").size.should eq(4)
  end

  it "should truncate to specified size if max_length passed" do
    subject.process("supercalifragilisticexpialidocious", 8).size.should eq(8)
  end

  it "should handle a max_length beyond code size" do
    subject.process("JUMP", 8).should eq("J510")
  end
end
