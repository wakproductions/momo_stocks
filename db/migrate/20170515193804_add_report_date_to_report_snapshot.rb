class AddReportDateToReportSnapshot < ActiveRecord::Migration[5.1]
  def change
    add_column :report_snapshots, :report_date, :date
  end
end
