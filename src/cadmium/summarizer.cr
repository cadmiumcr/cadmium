require "./summarizer/*"

module Cadmium
  module StringExtension
    def summarize(summarizer = Cadmium::LuhnSummarizer, *args, **kwargs)
      summarizer = summarizer.new(*args, **kwargs)
      summarizer.summarize(self)
    end
  end
end
