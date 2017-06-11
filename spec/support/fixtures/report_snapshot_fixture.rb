RSpec.shared_context 'report_snapshots fixtures' do
  let(:report_snapshot_premarket_2017_5_5) do
    {
      report_type: 'report_type_premarket',
      built_at: Time.new(2017,5,5,9,15,12),
      short_interest_as_of: Date.new(2017,4,30),
      institutional_ownership_as_of: Date.new(2017,5,5),
    }
  end
end