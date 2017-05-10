class CreateReportSnapshots < ActiveRecord::Migration[5.1]
  def change
    create_table :create_report_snapshots do |t|
      t.datetime :built_at
      t.integer :report_type

      t.timestamps
    end
  end
end

