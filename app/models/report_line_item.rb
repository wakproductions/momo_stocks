class ReportLineItem < ApplicationRecord
  include HasBulkInsert

  belongs_to :report_snapshot
end
