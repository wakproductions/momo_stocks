# frozen_string_literal: true

class ReportPresenter

  def self.call(report_sections)
    report_sections.each do |rs|
      rs.line_items = format_line_items(rs.line_items)
    end
  end

  def self.display_number(value, round=1)
    return unless (f = value.try(:to_f)).present?

    "%.#{round}f" % f
  end

  def self.display_percent(value, round=2)
    display_number(value, round).try(:+, '%')
  end

  private

  def self.format_line_items(line_items)
    line_items.map do |li|
      line_item = {
        symbol: li['symbol'],
        last_trade: display_number(li['last_trade'], 2),
        change_percent: display_number(li['change_percent'], 1),
        volume: display_number(li['volume'], 0),
        volume_average: display_number(li['volume_average'], 0),
        volume_average_premarket: display_number(li['volume_average_premarket'], 0),
        volume_ratio: display_number(li['volume_ratio'], 1),
        short_days_to_cover: display_number(li['short_days_to_cover']),
        short_percent_of_float: display_percent(li['short_percent_of_float'], 0),
        float: li['float'],
        float_percent_traded: display_percent(li['float_percent_traded'], 0),
        institutional_ownership_percent: display_percent(li['institutional_ownership_percent'], 0),
      }
    end
  end

end