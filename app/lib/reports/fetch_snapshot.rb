module Reports
  class FetchSnapshot
    include Verbalize::Action

    attr_reader :report_snapshot

    input :report_type, optional: [:id, :date]

    def call
      if @id
        @report_snapshot ||= ReportSnapshot.find_by(id: @id, report_type: report_type)
        fail! "Could not find the given report id #{@id}" if @report_snapshot.nil?
      else
        if @date
          # Get the most recent report for the given date
          @report_snapshot ||= ReportSnapshot.where(report_date: @date).order(built_at: :desc)
        else
          # Get the most recent report
          @report_snapshot ||= ReportSnapshot
            .where(report_type: report_type)
            .order(report_date: :desc, built_at: :desc)
            .last
        end
        fail! "Could not find a report for the given date" if @report_snapshot.nil?
      end

      @report_snapshot
    end

    private

  end
end