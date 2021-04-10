# frozen_string_literal: true

require "docx"
require "uri"

module Doc2pdf
  # Wraps a ::Docx::Document.
  class Document
    attr_reader :docx

    def initialize(file:)
      file = load_from_uri(file)

      self.docx = ::Docx::Document.open(file)
    end

    def save(path:)
      docx.save(path)
    end

    private

    def load_from_uri(file)
      return file unless file =~ URI::DEFAULT_PARSER.make_regexp

      URI.open(file)
    end

    attr_writer :docx
  end
end
