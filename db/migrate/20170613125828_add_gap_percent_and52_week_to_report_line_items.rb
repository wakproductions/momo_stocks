class AddGapPercentAnd52WeekToReportLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :report_line_items, :gap_percent, :float
    add_column :report_line_items, :percent_above_52_week_high, :float
  end
end
