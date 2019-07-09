require "./tokenizer"
require "../normalizers/remove_diacritics"

module Cadmium
  class AggressiveTokenizer < Tokenizer
    include Cadmium::Normalizers::RemoveDiacritics

    @lang : Symbol

    def initialize(*, lang = nil)
      @lang = lang.nil? ? :en : lang
    end

    # ameba:disable Metrics/CyclomaticComplexity
    def tokenize(string : String) : Array(String)
      case @lang
      when :es
        trim(string.split(/[^a-zA-Zá-úÁ-ÚñÑüÜ]+/))
      when :fa
        string = string.gsub(/\.\:\+\-\=\(\)\"\'\!\?\،\,\؛\;/, ' ')
        string.split(/\s+/).reject(&.empty?)
      when :fr
        trim(string.split(/[^a-z0-9äâàéèëêïîöôùüûœç]+/i))
      when :id
        string = string.gsub(/[^a-z0-9 -]/, ' ').gsub(/( +)/, ' ')
        trim(string.split(' '))
      when :nl
        trim(string.split(/[^a-zA-Z0-9_']+/))
      when :no
        trim(string.split(/[^A-Za-z0-9_æøåÆØÅäÄöÖüÜ]+/))
      when :pl
        string = string.gsub(/[^a-zążśźęćńół0-9]/i, ' ').gsub(/[\s\n]+/, ' ').strip
        string.split(' ').reject(&.empty?)
      when :pt
        trim(string.split(/[^a-zA-Zà-úÀ-Ú]/).reject(&.empty?))
      when :ru, :sr, :bg, :uk
        string = string.gsub(/[^a-zа-яё0-9]/i, ' ').gsub(/[\s\n]+/, ' ').strip
        string.split(' ').reject(&.empty?)
      when :sv
        string = remove_diacritics(string)
        trim(string.split(/[^A-Za-z0-9_åÅäÄöÖüÜ]+/))
      else
        trim(string.split(/\W+/))
      end
    end
  end
end
