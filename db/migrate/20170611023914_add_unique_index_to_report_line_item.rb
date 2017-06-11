class AddUniqueIndexToReportLineItem < ActiveRecord::Migration[5.1]
  def change
    add_index :report_line_items, [:report_snapshot_id, :symbol], name: :report_line_items_unique, unique: true
  end
end
