require "../../spec_helper"
include LongTexts

summary_length = {
  5 => "The great advantage of the mathematical sciences above the moral consists in this, that the ideas of the former, being sensible, are always clear and determinate, the smallest distinction between them is immediately perceptible, and the same terms are still expressive of the same ideas, without ambiguity or variation. If the mind, with greater facility, retains the ideas of geometry clear and determinate, it must carry on a much longer and more intricate chain of reasoning, and compare ideas much wider of each other, in order to reach the abstruser truths of that science. And if moral ideas are apt, without extreme care, to fall into obscurity and confusion, the inferences are always much shorter in these disquisitions, and the intermediate steps, which lead to the conclusion, much fewer than in the sciences which treat of quantity and number. The chief obstacle, therefore, to our improvement in the moral or metaphysical sciences is the obscurity of the ideas, and ambiguity of the terms. There are no ideas, which occur in metaphysics, more obscure and uncertain, than those of power, force, energy or necessary connexion, of which it is every moment necessary for us to treat in all our disquisitions.",
  2 => "The great advantage of the mathematical sciences above the moral consists in this, that the ideas of the former, being sensible, are always clear and determinate, the smallest distinction between them is immediately perceptible, and the same terms are still expressive of the same ideas, without ambiguity or variation. If the mind, with greater facility, retains the ideas of geometry clear and determinate, it must carry on a much longer and more intricate chain of reasoning, and compare ideas much wider of each other, in order to reach the abstruser truths of that science.",
  0 => "",
}

describe Cadmium::SumBasicSummarizer do
  subject = Cadmium::SumBasicSummarizer.new

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
    hume_text.summarize(Cadmium::SumBasicSummarizer).should eq(summary_length[5])
  end
end
