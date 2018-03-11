require "../../spec_helper"

describe Cadmium::Tokenizer::AggressiveTokenizer do
  describe "default language" do
    subject { described_class.new(lang: :en) }

    it "should tokenize strings" do
      expect(subject.tokenize("these are strings")).to eq(["these", "are", "strings"])
    end

    it "should tokenize strings via String#tokenize" do
      expect("these are strings".tokenize(Cadmium::Tokenizer::AggressiveTokenizer, lang: :en)).to eq(["these", "are", "strings"])
    end

    it "should allow punctuation" do
      expect(subject.tokenize("these are things, no")).to eq(["these", "are", "things", "no"])
    end

    it "should swollow final punctuation" do
      expect(subject.tokenize("these are things, no?")).to eq(["these", "are", "things", "no"])
    end

    it "should swollow initial punctuation" do
      expect(subject.tokenize(".these are things, no")).to eq(["these", "are", "things", "no"])
    end

    it "should swollow duplicate punctuation" do
      expect(subject.tokenize("i shal... pause")).to eq(["i", "shal", "pause"])
    end
  end

  describe ":es" do
    subject { described_class.new(lang: :es) }

    it "should tokenize strings" do
      expect(subject.tokenize("hola yo me llamo eduardo y esudié ingeniería")).to eq(["hola", "yo", "me", "llamo", "eduardo", "y", "esudié", "ingeniería"])
    end

    it "should tokenize strings via String#tokenize" do
      expect("hola yo me llamo eduardo y esudié ingeniería".tokenize(Cadmium::Tokenizer::AggressiveTokenizer, lang: :es)).to eq(["hola", "yo", "me", "llamo", "eduardo", "y", "esudié", "ingeniería"])
    end
  end

  describe ":fr" do
    subject { described_class.new(lang: :fr) }
    let(text) { "Affectueusement surnommé « Gabo » dans toute l'Amérique latine, le Colombien Gabriel Garcia Marquez, prix Nobel de littérature 1982, l'un des plus grands écrivains du XXe siècle, est mort À son domicile de Mexico jeudi 17 avril. Il était âgé de 87 ans. Son Œuvre a été traduite dans toutes les langues ou presque, et vendue à quelque 50 millions d'exemplaires." }
    let(tokenized) { ["Affectueusement", "surnommé", "Gabo", "dans", "toute", "l", "Amérique", "latine", "le", "Colombien", "Gabriel", "Garcia", "Marquez", "prix", "Nobel", "de", "littérature", "1982", "l", "un", "des", "plus", "grands", "écrivains", "du", "XXe", "siècle", "est", "mort", "À", "son", "domicile", "de", "Mexico", "jeudi", "17", "avril", "Il", "était", "âgé", "de", "87", "ans", "Son", "Œuvre", "a", "été", "traduite", "dans", "toutes", "les", "langues", "ou", "presque", "et", "vendue", "à", "quelque", "50", "millions", "d", "exemplaires"] }

    it "should tokenize strings" do
      expect(subject.tokenize(text)).to eq(tokenized)
    end

    it "should tokenize strings via String#tokenize" do
      expect(text.tokenize(Cadmium::Tokenizer::AggressiveTokenizer, lang: :fr)).to eq(tokenized)
    end
  end

  describe ":nl" do
    subject { described_class.new(lang: :nl) }

    it "should tokenize strings" do
      expect(subject.tokenize("'s Morgens is het nog erg koud, vertelde de weerman over een van de radio's")).to eq(["'s","Morgens","is","het","nog","erg","koud","vertelde","de","weerman","over","een","van","de","radio's"])
    end

    it "should tokenize strings via String#tokenize" do
      expect("'s Morgens is het nog erg koud, vertelde de weerman over een van de radio's".tokenize(Cadmium::Tokenizer::AggressiveTokenizer, lang: :nl)).to eq(["'s","Morgens","is","het","nog","erg","koud","vertelde","de","weerman","over","een","van","de","radio's"])
    end
  end

  describe ":pt" do
    subject { described_class.new(lang: :pt) }

    it "should tokenize strings" do
      expect(subject.tokenize("isso é coração")).to eq(["isso", "é", "coração"])
    end

    it "should tokenize strings via String#tokenize" do
      expect("isso é coração".tokenize(Cadmium::Tokenizer::AggressiveTokenizer, lang: :pt)).to eq(["isso", "é", "coração"])
    end

    it "should swollow punctuation" do
      expect(subject.tokenize("isso é coração, não")).to eq(["isso", "é", "coração", "não"])
    end

    it "should swollow final punctuation" do
      expect(subject.tokenize("isso é coração, não?")).to eq(["isso", "é", "coração", "não"])
    end

    it "should swollow initial punctuation" do
      expect(subject.tokenize(".isso é coração, não")).to eq(["isso", "é", "coração", "não"])
    end

    it "should swollow duplicate punctuation" do
      expect(subject.tokenize("eu vou... pause")).to eq(["eu", "vou", "pause"])
    end
  end
end
