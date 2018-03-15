require "../../spec_helper"

describe Cadmium::Phonetics::SoundEx do
  describe ".transform_lips" do
    it "should replace B, F, P, and V with 1" do
      expect(described_class.transform_lips("bopper")).to eq("1o11er")
      expect(described_class.transform_lips("valumf")).to eq("1alum1")
    end
  end

  describe ".transform_throats" do
    it "should replace C, G, J, K, Q, S, X, Z with 2" do
      expect(described_class.transform_throats("cagjjkiqsxz")).to eq("2a2222i2222")
    end
  end

  describe ".transform_tongue" do
    it "should replace D and T with 3" do
      expect(described_class.transform_tongue("dat")).to eq("3a3")
    end
  end

  describe "transform_l" do
    it "should replace L with 4" do
      expect(described_class.transform_l("lala")).to eq("4a4a")
    end
  end

  describe "transform_hum" do
    it "should replace M and N with 5" do
      expect(described_class.transform_hum("mummification")).to eq("5u55ificatio5")
    end
  end

  describe "transform_r" do
    it "should replace R with 6" do
      expect(described_class.transform_r("render")).to eq("6ende6")
    end
  end

  describe "condense" do
    it "sound condense sequences" do
      expect(described_class.condense("11222556")).to eq("1256")
    end
  end

  describe "pad_right_0" do
    it "sound padd zeros on the right to a lenght of 3" do
      expect(described_class.pad_right_0("1")).to eq("100")
      expect(described_class.pad_right_0("11")).to eq("110")
      expect(described_class.pad_right_0("111")).to eq("111")
    end
  end

  it "should not code the first character" do
    expect(described_class.process("render")[0]).to eq('R')
  end

  it "should pad right with zeros" do
    expect(described_class.process("super")).to eq("S160")
    expect(described_class.process("butt")).to eq("B300")
    expect(described_class.process("a")).to eq("A000")
  end

  it "should pad right with zeros" do
    expect(described_class.process("but")).to eq("B300")
  end

  it "should perform soundex" do
    expect(described_class.process("BLACKBERRY")).to eq("B216")
    expect(described_class.process("blackberry")).to eq("B216")
    expect(described_class.process("calculate")).to eq("C424")
    expect(described_class.process("CALCULATE")).to eq("C424")
    expect(described_class.process("fox")).to eq("F200")
    expect(described_class.process("FOX")).to eq("F200")
    expect(described_class.process("jump")).to eq("J510")
    expect(described_class.process("JUMP")).to eq("J510")
    expect(described_class.process("phonetics")).to eq("P532")
    expect(described_class.process("PHONETICS")).to eq("P532")
  end

  it "should perform soundex via compare method" do
    expect(described_class.compare("ant", "and")).to be_true
    expect(described_class.compare("ant", "anne")).to be_false
    expect(described_class.compare("band", "bant")).to be_true
    expect(described_class.compare("band", "gand")).to be_false
  end

  it "should perform soundex via attached sounds_like String patch" do
    expect("ant".sounds_like("ant", described_class)).to be_true
    expect("ant".sounds_like("anne", described_class)).to be_false
    expect("band".sounds_like("bant", described_class)).to be_true
    expect("band".sounds_like("gand", described_class)).to be_false
  end

  it "should return string phonetics with string patch" do
    expect("phonetics".phonetics(nil, described_class)).to eq("P532")
    expect("PHONETICS".phonetics(nil, described_class)).to eq("P532")
  end

  it "issue 221 -- inital vowels that duplicate cons codes" do
    expect("Lloyd".phonetics(nil, described_class)).to eq("L300")
    expect("Pfister".phonetics(nil, described_class)).to eq("P236")

    expect("manhattan".phonetics(nil, described_class)).to eq("M535")
    expect("Lukasiewicz".phonetics(nil, described_class)).to eq("L222")

    expect("Gauss".phonetics(nil, described_class)).to eq("G200")
    expect("Tymczak".phonetics(nil, described_class)).to eq("T522")
    expect("Jackson".phonetics(nil, described_class)).to eq("J250")
  end

  it "should tokenize and return string phonetics with string patch" do
    expect("phonetics".tokenize_and_phoneticize(false, described_class)).to eq(["P532"])
    expect("phonetics jump".tokenize_and_phoneticize(false, described_class)).to eq(["P532", "J510"])
    expect("phonetics jump calculate".tokenize_and_phoneticize(false, described_class)).to eq(["P532", "J510", "C424"])
  end

  it "should max out at four characters long by default" do
    expect(described_class.process("supercalifragilisticexpialidocious").size).to eq(4)
  end

  it "should truncate to specified size if max_length passed" do
    expect(described_class.process("supercalifragilisticexpialidocious", 8).size).to eq(8)
  end

  it "should handle a max_length beyond code size" do
    expect(described_class.process("JUMP", 8)).to eq("J510")
  end
end
