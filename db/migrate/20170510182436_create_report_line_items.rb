class CreateReportLineItems < ActiveRecord::Migration[5.1]
  def change
    create_table :report_line_items do |t|
      t.integer :report_snapshot_id

      t.string :symbol
      t.float :last_trade
      t.float :change_percent
      t.float :volume
      t.float :average_volume
      t.float :volume_ratio
      t.float :short_days_to_cover
      t.float :short_percent_of_float
      t.float :float
      t.float :float_percent_traded
      t.float :institutional_ownership_percent

      t.timestamps
    end
  end
end
