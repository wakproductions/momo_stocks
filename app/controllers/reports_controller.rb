class ReportsController < ApplicationController

  def active
    @fields = [:ticker_symbol, :last_trade, :change_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = build_report

    render :report
  end

  def after_hours
    @fields = [:ticker_symbol, :last_trade, :change_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = build_report

    render :report
  end

  def fifty_two_week_high
    @fields = [:ticker_symbol, :last_trade, :change_percent, :percent_above_52_week_high, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = build_report

    render :report
  end

  def gaps
    @fields = [:ticker_symbol, :last_trade, :change_percent, :gap_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = build_report

    render :report
  end

  def premarket
    @fields = [:ticker_symbol, :last_trade, :change_percent, :volume, :volume_average, :volume_ratio, :short_days_to_cover, :short_percent_of_float, :float, :float_percent_traded, :institutional_ownership_percent]
    @report = build_report

    render :report
  end

  private

  def build_report
    Reports::Presenters::SnapshotPresenter.format(
      report_snapshot,
      sorted_line_items,
      report_type,
      param_report_date
    ).merge(route: params[:action].to_sym)
  end

  def param_report_date
    @report_date ||= params[:report_date] ? Date.strptime(params[:report_date], '%m/%d/%Y') : nil
  end

  def report_type
    @report_type ||= "report_type_#{params[:action]}"
  end

  def report_snapshot
    @report_snapshot ||= Reports::Fetch::Base
      .call(report_snapshot: params[:report_snapshot_id] || param_report_date, report_type: params[:action])
      .value
  end

  def sort_field
    @sort_field ||= params[:sort_field].try(:to_sym) || :volume_ratio
  end

  def sorted_line_items
    return [] if report_snapshot.nil?
    @sorted_line_items ||= Reports::Presenters::LineItemSort
      .call(line_items: report_snapshot[:report_line_items] || [], sort_field: sort_field, sort_direction: :desc)
      .value
  end

end
