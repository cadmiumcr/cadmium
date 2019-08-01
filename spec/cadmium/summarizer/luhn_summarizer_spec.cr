require "../../spec_helper"
include LongTexts

summary_length = {
  5 => "The great advantage of the mathematical sciences above the moral consists in this, that the ideas of the former, being sensible, are always clear and determinate, the smallest distinction between them is immediately perceptible, and the same terms are still expressive of the same ideas, without ambiguity or variation. Our line is too short to fathom such immense abysses. And however we may flatter ourselves that we are guided, in every step which we take, by a kind of verisimilitude and experience, we may be assured that this fancied experience has no authority when we thus apply it to subjects that lie entirely out of the sphere of experience. But on this we shall have occasion to touch afterwards.14 Secondly, I cannot perceive any force in the arguments on which this theory is founded. We are ignorant, it is true, of the manner in which bodies operate on each other: Their force or energy is entirely incomprehensible: But are we not equally ignorant of the manner or force by which a mind, even the supreme mind, operates either on itself or on body?",
  2 => "The great advantage of the mathematical sciences above the moral consists in this, that the ideas of the former, being sensible, are always clear and determinate, the smallest distinction between them is immediately perceptible, and the same terms are still expressive of the same ideas, without ambiguity or variation. Our line is too short to fathom such immense abysses. And however we may flatter ourselves that we are guided, in every step which we take, by a kind of verisimilitude and experience, we may be assured that this fancied experience has no authority when we thus apply it to subjects that lie entirely out of the sphere of experience.",
  0 => "",
}

describe Cadmium::LuhnSummarizer do
  subject = Cadmium::LuhnSummarizer.new

  it "should summarize a long text to default number (5) sentences" do
    subject.summarize(hume_text).should eq(summary_length[5])
  end

  it "should summarize a long text according to the input max_num_sentences" do
    subject.summarize(hume_text, 2).should eq(summary_length[2])
  end

  it "should return an empty string if max_num_sentences is 0" do
    subject.summarize(hume_text, 0).should eq(summary_length[0])
  end

  it "should summarize text via String#summarize" do
    hume_text.summarize(Cadmium::LuhnSummarizer).should eq(summary_length[5])
  end
end
