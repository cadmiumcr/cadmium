require "../spec_helper"

describe Cadmium::Sentiment do
  subject = Cadmium::Sentiment

  it "should analyze a sentance and return a correct result" do
    tests = [
      {"You guys suck at football, we always beat you!", -3},
      {"I really hate how some poeple insist on arguing the superiority of their favorite language. Especially when that language is PHP.", -1},
      {"Here's a thing I do if I have to run mid-task 🤔", -1},
      {"Crystal is ❤️", 3},
      {"The best president, in my opinion, was Regan.", 3},
    ]

    tests.each do |(string, result)|
      subject.analyze(string)[:score].should eq(result)
    end
  end

  it "should work with attached string extensions" do
    "You guys suck at football, we always beat you!".sentiment[:score].should eq(-3)
    "Crystal is ❤️".is_positive?.should be_true
    "Here's a thing I do if I have to run mid-task 🤔".is_negative?.should be_true
  end
end
