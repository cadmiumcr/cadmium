include Cadmium::I18n::StopWords
stop_words en, fr
stop_words all_languages
describe Cadmium::I18n::StopWords do
  it "should return a word from the french stop words list" do
    stop_words_fr[2].should eq("absolument")
  end

  it "should return a word from the russian stop words list" do
    stop_words_all_languages["ru"][45].should eq("взгляд")
  end
end
