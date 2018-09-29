module Cadmium
  module Classifiers
    abstract class Classifier
      alias Document = NamedTuple(label: String, text: String)

      private getter docs : Array(Document)
      private getter features : Hash(String, Int32)
      private getter stemmer : Cadmium::Stemmers::Stemmer.class
      private getter last_added : Int32

      property keep_stops : Bool

      def initialize(stemmer = nil)
        @stemmer = stemmer || Cadmium::Stemmer::PorterStemmer
        @docs = [] of Document
        @features = {} of String => Int32
        @keep_stops = false
        @last_added = 0
      end

      abstract def add_example(features, label)

      def add_document(text : String | Array(String), label)
        label = label.to_s.strip

        if text.is_a?(String)
          text = stemmer.tokenize_and_stem(text, @keep_stops)
        end

        if text.size == 0
          return
        end

        docs.push({label: label, text: text})

        text.each do |token|
          @features[token] = (@features[token]? || 0) + 1
        end
      end

      def remove_document(text : String | Array(String), label)
        label = label.to_s.strip

        if text.is_a?(String)
          text = stemmer.tokenize_and_stem(text, @keep_stops)
        end

        docs.each_with_index do |doc, i|
          if doc.text.join(" ") == text.join(" ") && doc[:label] == label
            docs.delete_at(i)
            text.each { |token| @features[token] -= 1 if features[token]? }
          end
        end
      end

      def text_to_features(observation)
        if observation.is_a?(String)
          observation = stemmer.tokenize_and_stem(observation, @keep_stops)
        end

        @features.dup.select { |feature| observation.includes?(feature) }
      end

      def docs_to_features(docs)
        parsed_docs = [] of NamedTuple(index: Int32, features: Array(Int32))

        docs.each do |doc|
          features = [] of Int32

          @features.each do |feature|
            if doc[:observation].includes?(feature)
              features.push(1)
            else
              features.push(0)
            end
          end

          parsed_docs.push({index: doc[:index], features: features})
        end

        parsed_docs
      end

      def train
        total_docs = @docs.size
        (@last_added...total_docs).each do |i|
          features = text_to_features(@docs[i][:text])
          add_example(features, @docs[i][:label])
          @last_added += 1
        end
      end
    end
  end
end
