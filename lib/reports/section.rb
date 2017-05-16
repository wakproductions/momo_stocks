module Reports
  class Section

    attr_reader :title, :columns, :line_items

    def initialize(title, columns, line_items)
      @title = title
      @columns = columns
      @line_items = line_items
    end

  end
end