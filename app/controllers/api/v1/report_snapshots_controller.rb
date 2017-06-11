class API::V1::ReportSnapshotsController < ActionController::API
  before_action :validate_api_key, only: [:create]

  # POST /api/v1/report_snapshot
  def create
    Reports::InsertReportData.(input: report_snapshot_param.deep_symbolize_keys)
    render json: nil, status: :ok
  end

  private

  def report_snapshot_param
    params.require(:report_snapshot).permit(
      :built_at,
      :report_type,
      :institutional_ownership_as_of,
      :short_interest_as_of,
      :line_items=>Reports::InsertReportData::REPORT_LINE_ITEM_COLUMNS
    ).to_h
  end

  def validate_api_key
    render json: nil, status: :bad_request unless params[:api_key]==ENV['API_KEY']
  end
end


