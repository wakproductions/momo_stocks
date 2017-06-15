class ReportsController < ApplicationController

  def active
    @fields = [:ticker_symbol, :last_trade, :change_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = {
      title: 'Active Stocks Report',
      last_updated: report_snapshot[:built_at].in_time_zone("US/Eastern").strftime('%Y-%m-%d %H:%M:%S'),
      item_count: sorted_line_items.size,
      sections: Reports::Build::Sections::Active.(report: sorted_line_items).value,
      route: params[:action].to_sym,
    }

    render :report
  end

  def after_hours
    @fields = [:ticker_symbol, :last_trade, :change_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = {
      title: 'After Hours Stocks Report',
      last_updated: report_snapshot[:built_at].in_time_zone("US/Eastern").strftime('%Y-%m-%d %H:%M:%S'),
      item_count: sorted_line_items.size,
      sections: Reports::Build::Sections::AfterHours.(report: sorted_line_items).value,
      route: params[:action].to_sym,
    }

    render :report
  end

  def fifty_two_week_high
    @fields = [:ticker_symbol, :last_trade, :change_percent, :percent_above_52_week_high, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = {
      title: '52 Week Highs Report',
      last_updated: report_snapshot[:built_at].in_time_zone("US/Eastern").strftime('%Y-%m-%d %H:%M:%S'),
      item_count: sorted_line_items.size,
      sections: Reports::Build::Sections::FiftyTwoWeekHigh.(report: sorted_line_items).value,
      route: params[:action].to_sym,
    }

    render :report
  end

  def gaps
    @fields = [:ticker_symbol, :last_trade, :change_percent, :gap_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = {
      title: 'Overnight Gaps Report',
      last_updated: report_snapshot[:built_at].in_time_zone("US/Eastern").strftime('%Y-%m-%d %H:%M:%S'),
      item_count: sorted_line_items.size,
      sections: Reports::Build::Sections::Gaps.(report: sorted_line_items).value,
      route: params[:action].to_sym,
    }

    render :report
  end

  def premarket
    @fields = [:ticker_symbol, :last_trade, :change_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = {
      title: 'Premarket Report',
      last_updated: report_snapshot[:built_at].in_time_zone("US/Eastern").strftime('%Y-%m-%d %H:%M:%S'),
      item_count: sorted_line_items.size,
      sections: Reports::Build::Sections::Premarket.(report: sorted_line_items).value,
      route: params[:action].to_sym,
    }

    render :report
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
    @report_snapshot ||= Reports::Fetch::Base
      .call(report_snapshot: params[:report_snapshot_id] || params[:report_date], report_type: params[:action])
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
