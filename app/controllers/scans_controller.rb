class ScansController < ApplicationController
  # TODO before_filter :validate_report_title - check that the report exists

  def report
    @report_name = params[:report]
    @report_heading = report_name_to_heading(@report_name)
    @report = []

    # ReportPresenter.call(
    #   Reports::FetchAsSections.(
    #     report_type: report_name_to_report_type(@report_name),
    #     id: params[:id],
    #     date: params[:date]
    #   ).value
    # )
  end

  private

  def report_name_to_heading(title)
    case title.downcase
      when 'premarket'
        'Premarket Gaps'
    end
  end

  def report_name_to_report_type(title)
    "report_type_#{title}"
  end

end
