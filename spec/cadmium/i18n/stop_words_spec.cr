include Cadmium::I18n::StopWords
stop_words en, fr
stop_words all_languages
describe Cadmium::I18n::StopWords do
  subject = stop_words_fr

  it "should return a word from the french stop words list" do
    subject[2].should eq("absolument")
  end

  subject = stop_words_all_languages["ru"]

  it "should return a word from the russian stop words list" do
    subject[45].should eq("взгляд")
  end
end
