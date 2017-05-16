class ScansController < ApplicationController
  # TODO before_filter :validate_report_title - check that the report exists

  def report
    @report_title = params[:report]
    @report_heading = report_title_to_heading(@report_title)
    @report = Reports::Fetch.(
      report_type: report_title_to_report_type(@report_title),
      id: params[:id],
      date: params[:date]
    ).value
  end

  private

  def report_title_to_heading(title)
    case title.downcase
      when 'premarket'
        'Premarket Gaps'
    end
  end

  def report_title_to_report_type(title)
    "report_type_#{title}"
  end

end
