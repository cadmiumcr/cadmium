require "../../spec_helper"
require "summarizer_spec_helper"

describe Cadmium::LuhnSummarizer do
  summary_length = {
    5 => "",
    2 => "",
    0 => "",
  }

  subject = Cadmium::LuhnSummarizer.new

  it "should summarize a long text to default number (5) sentences" do
    subject.summarize(hume_text).should eq(summary_length[5])
  end
end
