class ReportSnapshot < ActiveRecord::Base
  has_many :report_line_items

  enum report_type: {
    report_type_premarket:      1,
    report_type_gaps:           2,
    report_type_52_week_highs:  3,
    report_type_active_stocks:  4,
  }

  validates :built_at, presence: true

  after_validation :set_report_date

  private

  def set_report_date
    self.report_date = self.built_at.to_date
  end

end
