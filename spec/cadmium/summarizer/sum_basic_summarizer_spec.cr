require "../../spec_helper"
include LongTexts

summary_length = {
  5 => "But the finer sentiments of the mind, the operations of the understanding, the various agitations of the passions, though really in themselves distinct, easily escape us, when surveyed by reflection; nor is it in our power to recal the original object, as often as we have occasion to contemplate it. But the finer sentiments of the mind, the operations of the understanding, the various agitations of the passions, though really in themselves distinct, easily escape us, when surveyed by reflection; nor is it in our power to recal the original object, as often as we have occasion to contemplate it. But the finer sentiments of the mind, the operations of the understanding, the various agitations of the passions, though really in themselves distinct, easily escape us, when surveyed by reflection; nor is it in our power to recal the original object, as often as we have occasion to contemplate it. But the finer sentiments of the mind, the operations of the understanding, the various agitations of the passions, though really in themselves distinct, easily escape us, when surveyed by reflection; nor is it in our power to recal the original object, as often as we have occasion to contemplate it. But the finer sentiments of the mind, the operations of the understanding, the various agitations of the passions, though really in themselves distinct, easily escape us, when surveyed by reflection; nor is it in our power to recal the original object, as often as we have occasion to contemplate it.",
  2 => "But the finer sentiments of the mind, the operations of the understanding, the various agitations of the passions, though really in themselves distinct, easily escape us, when surveyed by reflection; nor is it in our power to recal the original object, as often as we have occasion to contemplate it. But the finer sentiments of the mind, the operations of the understanding, the various agitations of the passions, though really in themselves distinct, easily escape us, when surveyed by reflection; nor is it in our power to recal the original object, as often as we have occasion to contemplate it.",
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
