class AddSnapshotTimeToReportLineItems < ActiveRecord::Migration[5.1]
  def change
    add_column :report_line_items, :snapshot_time, :datetime
  end
end
