require 'rails_helper'

RSpec.describe Reports::InsertReportData do
  subject { described_class.call(input: input) }
  include_context 'report_snapshots fixtures'
  include_context 'report_line_items fixtures'
  let(:input) do
    hash_values_to_string(report_snapshot_premarket_2017_5_5).merge(
      {
        line_items: report_line_items_premarket_2017_5_5
      }
    )
  end

  def find_report_snapshot(attr)
    ReportSnapshot.where(attr)
  end

  def find_report_line_item(attr)
    ReportLineItem.where(report_snapshot_id: attr[:report_snapshot_id], ticker_symbol: attr[:symbol])
  end

  def hash_values_to_string(hash)
    newhash = {}
    hash.keys.each {|k| newhash[k]=hash[k].to_s}
    newhash
  end

  it 'inserts the expected data' do
    expect(ReportSnapshot.count).to eql(0)
    expect(ReportLineItem.count).to eql(0)

    subject
    expect(ReportSnapshot.count).to eql(1)

    rs_id = ReportSnapshot.first.id

    expect(find_report_snapshot(report_snapshot_premarket_2017_5_5)).to be_present
    input[:line_items].each do |li|
      # Not testing for contents just yet
      expect(find_report_line_item(li.merge(report_snapshot_id: rs_id))).to be_present,
        "Couldn't find line item: #{li}"
    end
  end
end