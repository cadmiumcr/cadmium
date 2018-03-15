require "../spec_helper"

describe Cadmium::Sentiment do
  it "should analyze a sentance and return a correct result" do
    tests = [
      {"You guys suck at football, we always beat you!", -3},
      {"I really hate how some poeple insist on arguing the superiority of their favorite language. Especially when that language is PHP.", -1},
      {"Here's a thing I do if I have to run mid-task 🤔", -1},
      {"Crystal is ❤️", 3},
      {"The best president, in my opinion, was Regan.", 3},
    ]

    tests.each do |(string, result)|
      expect(described_class.analyze(string)[:score]).to eq(result)
    end
  end

  it "should work with attached string extensions" do
    expect("You guys suck at football, we always beat you!".sentiment[:score]).to eq(-3)
    expect("Crystal is ❤️".is_positive?).to be_true
    expect("Here's a thing I do if I have to run mid-task 🤔".is_negative?).to be_true
  end
end
