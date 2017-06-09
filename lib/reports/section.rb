module Reports
  class Section

    attr_accessor :line_items
    attr_reader :title, :columns

    def initialize(title, columns, line_items)
      @title = title
      @columns = columns
      @line_items = line_items
    end

  end
end