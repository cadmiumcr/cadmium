require "../../spec_helper"

describe Cadmium::Tokenizer::CaseTokenizer do
  subject = Cadmium::Tokenizer::CaseTokenizer.new

  it "should tokenize numbers" do
    subject.tokenize("0 1 2 3 4 5 6 7 8 9 10").should eq(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"])
  end

  describe "spanish" do
    it "should tokenize strings" do
      subject.tokenize("hola yo me llamo eduardo y esudié ingeniería").should eq(["hola", "yo", "me", "llamo", "eduardo", "y", "esudié", "ingeniería"])
    end

    it "should tokenize strings via String#tokenize" do
      "hola yo me llamo eduardo y esudié ingeniería".tokenize(Cadmium::Tokenizer::CaseTokenizer).should eq(["hola", "yo", "me", "llamo", "eduardo", "y", "esudié", "ingeniería"])
    end
  end

  describe "french" do
    text = "Affectueusement surnommé « Gabo » dans toute l'Amérique latine, le Colombien Gabriel Garcia Marquez, prix Nobel de littérature 1982, l'un des plus grands écrivains du XXe siècle, est mort À son domicile de Mexico jeudi 17 avril. Il était âgé de 87 ans. Son Œuvre a été traduite dans toutes les langues ou presque, et vendue à quelque 50 millions d'exemplaires."
    tokenized = ["Affectueusement", "surnommé", "Gabo", "dans", "toute", "l", "Amérique", "latine", "le", "Colombien", "Gabriel", "Garcia", "Marquez", "prix", "Nobel", "de", "littérature", "1982", "l", "un", "des", "plus", "grands", "écrivains", "du", "XXe", "siècle", "est", "mort", "À", "son", "domicile", "de", "Mexico", "jeudi", "17", "avril", "Il", "était", "âgé", "de", "87", "ans", "Son", "Œuvre", "a", "été", "traduite", "dans", "toutes", "les", "langues", "ou", "presque", "et", "vendue", "à", "quelque", "50", "millions", "d", "exemplaires"]

    it "should tokenize strings" do
      subject.tokenize(text).should eq(tokenized)
    end

    it "should tokenize strings via String#tokenize" do
      text.tokenize(Cadmium::Tokenizer::CaseTokenizer).should eq(tokenized)
    end
  end

  describe "dutch" do
    dutch_tokenizer = Cadmium::Tokenizer::CaseTokenizer.new(preserve_apostrophe: true)

    it "should tokenize strings" do
      dutch_tokenizer.tokenize("'s Morgens is het nog erg koud, vertelde de weerman over een van de radio's").should eq(["'s", "Morgens", "is", "het", "nog", "erg", "koud", "vertelde", "de", "weerman", "over", "een", "van", "de", "radio's"])
    end

    it "should tokenize strings via String#tokenize" do
      "'s Morgens is het nog erg koud, vertelde de weerman over een van de radio's".tokenize(Cadmium::Tokenizer::CaseTokenizer, preserve_apostrophe: true).should eq(["'s", "Morgens", "is", "het", "nog", "erg", "koud", "vertelde", "de", "weerman", "over", "een", "van", "de", "radio's"])
    end
  end

  describe "portuguese" do
    it "should tokenize strings" do
      subject.tokenize("isso é coração").should eq(["isso", "é", "coração"])
    end

    it "should tokenize strings via String#tokenize" do
      "isso é coração".tokenize(Cadmium::Tokenizer::CaseTokenizer).should eq(["isso", "é", "coração"])
    end

    it "should swollow punctuation" do
      subject.tokenize("isso é coração, não").should eq(["isso", "é", "coração", "não"])
    end

    it "should swollow final punctuation" do
      subject.tokenize("isso é coração, não?").should eq(["isso", "é", "coração", "não"])
    end

    it "should swollow initial punctuation" do
      subject.tokenize(".isso é coração, não").should eq(["isso", "é", "coração", "não"])
    end

    it "should swollow duplicate punctuation" do
      subject.tokenize("eu vou... pause").should eq(["eu", "vou", "pause"])
    end
  end

  describe "aggressive" do
    it "should tokenize strings" do
      subject.tokenize("these are strings").should eq(["these", "are", "strings"])
    end

    it "should tokenize strings via String#tokenize" do
      "these are strings".tokenize(Cadmium::Tokenizer::CaseTokenizer).should eq(["these", "are", "strings"])
    end

    it "should allow punctuation" do
      subject.tokenize("these are things, no").should eq(["these", "are", "things", "no"])
    end

    it "should swollow final punctuation" do
      subject.tokenize("these are things, no?").should eq(["these", "are", "things", "no"])
    end

    it "should swollow initial punctuation" do
      subject.tokenize(".these are things, no").should eq(["these", "are", "things", "no"])
    end

    it "should swollow duplicate punctuation" do
      subject.tokenize("i shal... pause").should eq(["i", "shal", "pause"])
    end
  end

  describe "italian" do
    it "should tokenize strings" do
      subject.tokenize("Mi piacerebbe visitare l\'Italia un giorno di questi!").should eq(["Mi", "piacerebbe", "visitare", "l", "Italia", "un", "giorno", "di", "questi"])
    end
  end

  describe "norwegian" do
    it "should tokenize strings" do
      subject.tokenize("Gå rett fram. Så tek du til venstre/høgre.").should eq(["Gå", "rett", "fram", "Så", "tek", "du", "til", "venstre", "høgre"])
    end
  end
end
