module Reports
  module Fetch
    class Base
      include Verbalize::Action

      attr_reader :report_snapshot

      input :report_type,
            :report_snapshot # can be a date or report snapshot id number

      def call
        if report_snapshot_ar.present?
          report_snapshot_attributes.merge(report_line_items: report_line_items)
        else
          {

          }
        end
      end

      private

      def report_line_items
        @report_line_items ||= report_snapshot_ar.report_line_items
      end

      def report_snapshot_attributes
        @report_snapshot_attributes ||= report_snapshot_ar.attributes.symbolize_keys
      end

      def report_snapshot_ar
        if report_snapshot.is_a? Integer
          # find the appropriate report snapshot by ID
        elsif report_snapshot.is_a? Date
          @report_snapshot_ar ||= ReportSnapshot
            .joins(:report_line_items)
            .where(report_type: "report_type_#{report_type}", report_date: report_snapshot)
            .order(id: :desc)
            .first
        else
          @report_snapshot_ar ||= ReportSnapshot
            .joins(:report_line_items)
            .where(report_type: "report_type_#{report_type}")
            .order(id: :desc)
            .first
        end
      end
    end
  end
end