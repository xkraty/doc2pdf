# frozen_string_literal: true

require_relative "doc2pdf/version"
require_relative "doc2pdf/document"
require_relative "doc2pdf/document_traversal"
require "libreconv"
require 'tempfile'
require 'open-uri'

# Module containing some helper methods that searches and replaces placeholders in a .doc file.
module Doc2pdf
  class Error < StandardError; end

  # Example: "foo {bar} spam {egg} asd" -> ['{bar}', '{egg}']
  PLACEHOLDER_PATTERN = /({\w*})/.freeze

  def self.extract(document:)
    DocumentTraversal.new(document: document).map do |item|
      search(item.text)
    end.flatten
  end

  def self.replace!(document:, replacer:)
    DocumentTraversal.new(document: document).each do |item|
      search(item.text).each do |occurrence|
        item.substitute(occurrence, replacer.call(key: occurrence))
      end
    end

    document
  end

  def self.replace_and_save!(file:, output_path:, replacer:)
    FileUtils.mkdir_p(File.dirname(output_path))

    if file =~ URI::DEFAULT_PARSER.make_regexp
      tmp = Tempfile.new
      IO.copy_stream(URI.open(file), tmp.path)
      file = tmp.path
    end

    document = Document.new(file: file)

    replace!(document: document, replacer: replacer)

    begin
      temp_doc = Tempfile.new
      document.save(path: temp_doc.path) # saves a copy
      Libreconv.convert(temp_doc.path, output_path) # converts the doc copy into a pdf copy
    rescue
      temp_doc.close
      temp_doc.unlink
    end
  end

  def self.search(text)
    text.scan(PLACEHOLDER_PATTERN).flatten
  end
end
