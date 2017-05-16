module Reports
  class Fetch
    include Verbalize::Action

    attr_reader :report_snapshot

    input :report_type, optional: [:id, :date]

    def call
      @report = []
      report_by_sections
    end

    private

    def report_by_sections
      case report_type
        when 'report_type_premarket'
          sections_premarket
      else
        fail! "Unknown report type: #{report_type}"
      end
    end

    def report_line_items
      @report_line_items = report_snapshot.report_line_items
    end

    def report_snapshot
      @report_snapshot ||= FetchSnapshot.(report_type: report_type, id: @id, date: @date).value
    end

    def sections_premarket
      # If only we could use Elixir tuples for this :)
      columns = [
        :symbol,
        :last_trade,
        :change_percent,
        :volume,
        :average_volume,
        :volume_ratio,
        :short_days_to_cover,
        :short_percent_of_float,
        :float,
        :float_percent_traded,
        :institutional_ownership_percent,
      ]
      @report << Section.new(
        'Gap Ups, By Volume',
        columns,
        report_line_items
          .select { |r| r[:change_percent].to_f >= 0 && r[:average_volume] > 0 }
          .sort { |r1, r2| r2[:average_volume] <=> r1[:average_volume]}
          .first(50)
      )
      @report << Section.new(
        'Gaps By Percent (No Average ',
        columns,
        report_line_items
          .select { |r| r[:change_percent].to_f < 0 && r[:average_volume] > 0 }
          .sort { |r1, r2| r2[:average_volume] <=> r1[:average_volume]}
          .first(50)
      )
      @report << Section.new(
        'Gap Downs, By Volume',
        columns,
        report_line_items
          .select { |r| r[:average_volume].nil? || r[:average_volume] == 0 }
          .sort { |r1, r2| r2[:change_percent] <=> r1[:change_percent]}
          .first(50)
      )
    end

  end
end