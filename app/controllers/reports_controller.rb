class ReportsController < ApplicationController

  def active

  end

  def after_hours

  end

  def fifty_two_week_high

  end

  def gaps

  end

  def premarket
    @fields = [:ticker_symbol, :last_trade, :change_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent, :actions]
    @report = {
      title: 'Premarket Report',
      last_updated: report_snapshot[:built_at].in_time_zone("US/Eastern").strftime('%Y-%m-%d %H:%M:%S'),
      item_count: sorted_line_items.size,
      sections: Reports::Build::Sections::Premarket.(report: sorted_line_items).value,
      route: :premarket,
    }

    render :report
  end

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

  def report_snapshot
    @report_snapshot ||= eval("Reports::Fetch::#{params[:action].camelcase}")
      .call(report_snapshot: params[:report_snapshot_id] || params[:report_date])
      .value
  end

  def sort_field
    @sort_field ||= params[:sort_field].try(:to_sym) || :volume_ratio
  end

  def sorted_line_items
    @sorted_line_items ||= Reports::Presenters::LineItemSort
      .call(line_items: report_snapshot[:report_line_items], sort_field: sort_field, sort_direction: :desc)
      .value
  end

end
