# frozen_string_literal: true

require 'docx'

module Doc2pdf
  class Document
    attr_reader :docx

    def initialize(file:)
      self.docx = Docx::Document.open(file)
    end

    def save(path:)
      docx.save(path)
    end

    private

    attr_writer :docx
  end
end
