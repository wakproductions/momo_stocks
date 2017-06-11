require 'rails_helper'

RSpec.describe API::V1::ReportSnapshotsController do
  describe "POST create" do

    context 'without a valid API key' do
      it 'returns an error' do
        post :create, format: :json, params: {report_snapshot: [{item1: 'yes'}]}
        expect(response.status).to eql(400)
      end
    end

    context 'with a valid API key' do
      include_context 'report_snapshots fixtures'
      include_context 'report_line_items fixtures'
      let(:input) do
        report_snapshot_premarket_2017_5_5.merge(
          {
            line_items: report_line_items_premarket_2017_5_5
          }
        )
      end

      it 'saves the received data' do
        post :create, format: :json, params: {api_key: ENV['API_KEY'], report_snapshot: input}
        expect(response.status).to eql(200)
        expect(ReportSnapshot.count).to eql(1)
        expect(ReportLineItem.count).to eql(report_line_items_premarket_2017_5_5.size)
      end
    end
  end
end