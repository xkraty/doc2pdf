# frozen_string_literal: true

module Doc2pdf
  # Walks each text section of a document.
  class DocumentTraversal
    include Enumerable

    def initialize(document:)
      self.document = document
    end

    def each(&block)
      paragraphs do |text|
        block.call(text)
      end

      tables do |text|
        block.call(text)
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
            paragraphs(&block)
          end
        end
      end
    end

    def area
      document.docx
    end
  end
end
