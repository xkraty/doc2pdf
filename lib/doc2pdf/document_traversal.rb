# frozen_string_literal: true

module Doc2pdf
  class DocumentTraversal
    include Enumerable

    def initialize(document:)
      self.document = document
    end

    def each(&block)
      paragraphs do |text|
        yield text
      end

      tables do |text|
        yield text
      end
    end

    private

    attr_accessor :document

    def paragraphs(&block)
      area.paragraphs.each do |paragraph|
        paragraph.each_text_run(&block)
      end
    end

    def tables(&block)
      area.tables.each do |table|
        table.rows.each do |row|
          row.cells.each do |cell|
            paragraphs(cell, &block)
          end
        end
      end
    end

    def area
      document.docx
    end
  end
end
