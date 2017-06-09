class AddPremarketVolumeAverageToReportLineItems < ActiveRecord::Migration[5.1]
  def change
    rename_column :report_line_items, :average_volume, :volume_average
    add_column :report_line_items, :volume_average_premarket, :float
    add_column :report_line_items, :volume_ratio_premarket, :float
  end
end
