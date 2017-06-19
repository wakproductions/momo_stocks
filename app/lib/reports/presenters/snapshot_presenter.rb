module Reports
  module Presenters
    module SnapshotPresenter
      extend self

      # Report type parameter is kind of a hack. If the report snapshot could not be found and you pass in nil,
      # report_type parameter is used to determine what title to display. It's basically an "intended" report type.
      def format(report_snapshot, line_items, report_type=nil, report_date=nil)
        if report_snapshot.present?
          {
            title: report_title(report_snapshot[:report_type]),
            last_updated: built_at_text(report_snapshot[:built_at]),
            report_date: report_date_text(report_snapshot[:built_at]),
            item_count: line_items.size,
            sections: eval("Reports::Build::Sections::#{report_type_no_prefix(report_snapshot[:report_type]).camelcase}").(report: line_items).value,
          }
        else
          {
            title: report_title(report_type),
            last_updated: 'N/A',
            report_date: report_date_text(report_date),
            item_count: '0',
            sections: [],
          }
        end
      end

      def built_at_text(built_at)
        built_at.in_time_zone("US/Eastern").strftime('%Y-%m-%d %H:%M:%S')
      end

      def report_date_text(built_at)
        built_at.in_time_zone("US/Eastern").strftime('%m/%d/%Y')
      end

      def report_title(report_type)
        case report_type
          when 'report_type_active'
            'Active Stocks Report'
          when 'report_type_after_hours'
            'After Hours Stocks Report'
          when 'report_type_fifty_two_week_high'
            '52 Week Highs Report'
          when 'report_type_gaps'
            'Overnight Gaps Report'
          when 'report_type_premarket'
            'Premarket Report'
          else
            'Report Name N/A'
        end
      end

      def report_type_no_prefix(report_type)
        report_type.gsub('report_type_', '')
      end
    end
  end
end