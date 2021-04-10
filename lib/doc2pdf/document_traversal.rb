# frozen_string_literal: true

module Doc2pdf
  # Walks each text section of a document.
  class DocumentTraversal
    include Enumerable

    def initialize(document:)
      self.document = document
    end

    def each(&block)
      paragraphs(docx) do |text|
        block.call(text)
      end

      tables do |text|
        block.call(text)
      end
    end

    private

    attr_accessor :document

    def paragraphs(area, &block)
      area.paragraphs.each do |paragraph|
        paragraph.each_text_run(&block)
      end
    end

    def tables(&block)
      docx.tables.each do |table|
        table.rows.each do |row|
          row.cells.each do |cell|
            paragraphs(cell, &block)
          end
        end
      end
    end

    def docx
      document.docx
    end
  end
end
