module Reports
  class InsertReportData
    include Verbalize::Action

    REPORT_SNAPSHOT_COLUMNS=[:built_at, :report_type, :short_interest_as_of, :institutional_ownership_as_of]
    REPORT_LINE_ITEM_COLUMNS=[
      :ticker_symbol,
      :last_trade,
      :change_percent,
      :float,
      :float_percent_traded,
      :short_days_to_cover,
      :short_percent_of_float,
      :snapshot_time,
      :institutional_ownership_percent,
      :volume,
      :volume_average,
      :volume_ratio,
      # :volume_average_premarket, # for the premarket report just using volume_average
      # :volume_ratio_premarket,   # for the premarket report just using volume_ratio
    ]

    input :input

    def call
      rs = ReportSnapshot.create!(report_snapshot)
      ReportLineItem.bulk_insert(
        line_items.map do |li|
          li.slice(*REPORT_LINE_ITEM_COLUMNS).merge(report_snapshot_id: rs.id)
        end
      )
    end

    private

    def line_items
      input[:line_items]
    end

    def report_snapshot
      @report_snapshot ||= {
        report_type: input[:report_type],
        built_at: Time.parse(input[:built_at]),
        short_interest_as_of: input[:short_interest_as_of].present? ? Time.parse(input[:short_interest_as_of]) : nil,
        institutional_ownership_as_of: input[:institutional_ownership_as_of].present? ? Time.parse(input[:institutional_ownership_as_of]) : nil,
        report_date: input[:report_date] || Time.parse(input[:built_at]).to_date,
      }
    end

  end
end