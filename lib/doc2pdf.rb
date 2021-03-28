# frozen_string_literal: true

require_relative "doc2pdf/version"
require_relative "doc2pdf/document"
require_relative "doc2pdf/document_traversal"
require 'libreconv'

module Doc2pdf
  class Error < StandardError; end

  # Example: "foo {bar} spam {egg} asd" -> ['bar', 'egg']
  PLACEHOLDER_PATTERN = /{(\w*)}/

  def self.extract(document:)
    DocumentTraversal.new(document: document).map do |item|
      search(item.text)
    end.flatten
  end

  def self.replace!(document:)
    DocumentTraversal.new(document: document).each do |item|
      search(item.text).each do |occurrence|
        item.substitute(occurrence, 'QUALCOSA')
      end
    end

    document
  end

  def self.replace_and_save!(document:, output_base_path:)
    FileUtils.mkdir_p(File.dirname(output_base_path))

    replace!(document: document)

    doc_path = "#{output_base_path}.doc"
    pdf_path = "#{output_base_path}.pdf"

    document.save(path: doc_path) # saves a copy
    Libreconv.convert(doc_path, pdf_path) # converts the doc copy into a pdf copy

    {
      pdf: pdf_path,
      doc: doc_path,
    }
  end

  def self.search(text)
    text.scan(PLACEHOLDER_PATTERN).flatten
  end
end