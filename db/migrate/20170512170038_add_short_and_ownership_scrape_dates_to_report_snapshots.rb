class AddShortAndOwnershipScrapeDatesToReportSnapshots < ActiveRecord::Migration[5.1]
  def change
    add_column :report_snapshots, :short_interest_as_of, :date
    add_column :report_snapshots, :institutional_ownership_as_of, :date
  end
end
