module Reports
  module Build
    module SQL
      # The goal will be to eventually move the SQL query strings out of the TDAmeritradeDataInterface namespace and put them here
      # extend TDAmeritradeDataInterface::SQLQueryStrings

      def select_52_week_highs(most_recent_date)
        <<SQL
with ticker_list as 
(
  select
    ticker_symbol, high, close as last_trade, volume,
    (close/previous_close-1)*100 as pct_change,
    average_volume_50day as average_volume,
    volume / average_volume_50day as volume_ratio,
    float,
    case when volume > 0 and t.float > 0 then volume / t.float * 100 end as float_percent_traded, 
    high_52_week,
    (close/high_52_week-1)*100 as pct_above_52_week,
    snapshot_time,
    t.short_ratio as short_ratio,
    t.short_pct_float * 100 as short_percent_of_float,
    t.institutional_holdings_percent as institutional_ownership_percent,  
    t.hide_from_reports_until > current_date as gray_symbol
  from daily_stock_prices dsp inner join tickers t on dsp.ticker_symbol=t.symbol
  where 
    price_date='#{most_recent_date.strftime('%Y-%m-%d')}' and
    volume > 20 and
    close > high_52_week and
    close > 1 and 
    t.scrape_data
)
select
  ticker_symbol,
  last_trade,
  pct_change as change_percent,
  volume,
  average_volume as volume_average,
  volume_ratio,
  float,
  float_percent_traded,
  pct_above_52_week as percent_above_52_week_high,
  snapshot_time,
  short_ratio as short_days_to_cover,
  short_percent_of_float,
  institutional_ownership_percent,
  gray_symbol
from ticker_list
order by
  volume_ratio desc
SQL
      end


      def select_active(most_recent_date)
        <<SQL
select
  ticker_symbol,
  price_date,
  close as last_trade,
  ((close / previous_close) - 1) * 100 as change_percent,
  volume as volume,
  average_volume_50day as volume_average,
  volume / average_volume_50day as volume_ratio,
  t.float,
  case when volume > 0 and t.float > 0 then volume / t.float * 100 end as float_percent_traded,
  snapshot_time,
  t.short_ratio as short_days_to_cover,
  t.short_pct_float * 100 as short_percent_of_float,
  t.institutional_holdings_percent as institutional_ownership_percent,
  t.hide_from_reports_until > current_date as gray_symbol

from daily_stock_prices d inner join tickers t on t.symbol=d.ticker_symbol
where
t.scrape_data=true and
abs((((close / previous_close) - 1) * 100)) > 2 and
price_date = '#{most_recent_date.strftime('%Y-%m-%d')}' and
(close * volume > 5000)
order by volume_ratio desc
limit 50
SQL
      end

      def select_after_hours_by_percent(report_date)
        <<SQL
select
  ticker_symbol,
  last_trade,
  ((last_trade / intraday_close) - 1) * 100 as change_percent,
  intraday_close,
  volume as volume,
  average_volume_50day as volume_average,
  '---' as volume_ratio,
  price_date,
  p.updated_at as snapshot_time,
  t.float,
  case when volume > 0 and t.float > 0 then volume / t.float * 100 end as float_percent_traded,   
  t.short_ratio as short_days_to_cover,
  t.short_pct_float * 100 as short_percent_of_float,
  t.institutional_holdings_percent as institutional_ownership_percent,  
  t.hide_from_reports_until > current_date as gray_symbol
from after_hours_prices p inner join tickers t on p.ticker_symbol=t.symbol
where
t.scrape_data and
last_trade is not null and
last_trade > 1 and
volume > 10 and
intraday_close is not null and
average_volume_50day = 0 and
price_date = '#{report_date.strftime('%Y-%m-%d')}' and
((last_trade / intraday_close) - 1) * 100 > 1
order by change_percent desc
limit 50
SQL
      end

      def select_after_hours_by_volume(report_date)
        <<SQL
select
  ticker_symbol,
  last_trade,
  ((last_trade / intraday_close) - 1) * 100 as change_percent,
  intraday_close,
  volume as volume,
  average_volume_50day as volume_average,
  volume / average_volume_50day as volume_ratio,
  price_date,
  p.updated_at as snapshot_time,
  t.float,
  case when volume > 0 and t.float > 0 then volume / t.float * 100 end as float_percent_traded,   
  t.short_ratio as short_days_to_cover,
  t.short_pct_float * 100 as short_percent_of_float,
  t.institutional_holdings_percent as institutional_ownership_percent,  
  t.hide_from_reports_until > current_date as gray_symbol
from after_hours_prices p inner join tickers t on p.ticker_symbol=t.symbol
where
t.scrape_data and
last_trade is not null and
volume is not null and
volume > 10 and
last_trade > 1 and
intraday_close is not null and
average_volume_50day is not null and
average_volume_50day > 0 and
(((last_trade / intraday_close) - 1) * 100 < -2 or ((last_trade / intraday_close) - 1) * 100 > 2) and
price_date = '#{report_date.strftime('%Y-%m-%d')}'
order by volume_ratio desc
limit 50
SQL
      end

      def select_gaps(most_recent_date)
      <<SQL
select
  ticker_symbol,
  price_date,
  close as last_trade,
  (close / previous_close-1)*100 as change_percent,
  volume as volume,
  average_volume_50day as volume_average,
  volume / average_volume_50day as volume_ratio,
  t.float,
  case when volume > 0 and t.float > 0 then volume / t.float * 100 end as float_percent_traded,
  snapshot_time,
  (open / previous_high-1)*100 as gap_percent,
  t.short_ratio as short_days_to_cover,
  t.short_pct_float * 100 as short_percent_of_float,
  t.institutional_holdings_percent as institutional_ownership_percent,  
  t.hide_from_reports_until > current_date as gray_symbol
from daily_stock_prices d
inner join tickers t on d.ticker_symbol=t.symbol
where
t.scrape_data = true and
close > 1 and
volume > 100 and
(
  (low > previous_high and open / previous_high > 1.03) or (high < previous_low and open / previous_low < 0.97)  
) and
price_date = '#{most_recent_date.strftime('%Y-%m-%d')}' 
order by volume_ratio desc
SQL
      end

      def select_premarket_by_percent(report_date)
        <<SQL
select
  ticker_symbol,
  last_trade,
  ((last_trade / previous_close) - 1) * 100 as change_percent,
  previous_close,
  volume as volume,
  average_volume_50day as volume_average,
  '---' as volume_ratio,
  t.short_ratio as short_days_to_cover,
  t.short_pct_float * 100 as short_percent_of_float,
  price_date,
  p.updated_at as snapshot_time,
  t.float,
  case when volume > 0 and t.float > 0 then volume / t.float * 100 end as float_percent_traded,   
  t.institutional_holdings_percent as institutional_ownership_percent,
  t.hide_from_reports_until > current_date as gray_symbol
from premarket_prices p inner join tickers t on p.ticker_symbol=t.symbol
where
t.scrape_data and
last_trade is not null and
volume > 8 and
previous_close is not null and
average_volume_50day = 0 and
price_date = '#{report_date.strftime('%Y-%m-%d')}'
order by change_percent desc
limit 50
SQL
      end

      def select_premarket_by_volume(report_date)
        <<SQL
select
  ticker_symbol,
  last_trade,
  ((last_trade / previous_close) - 1) * 100 as change_percent,
  previous_close,
  volume as volume,
  average_volume_50day as volume_average,
  volume / average_volume_50day as volume_ratio,
  t.short_ratio as short_days_to_cover,
  t.short_pct_float * 100 as short_percent_of_float,
  price_date,
  p.updated_at as snapshot_time,
  t.float,
  case when volume > 0 and t.float > 0 then volume / t.float * 100 end as float_percent_traded,   
  t.institutional_holdings_percent as institutional_ownership_percent,
  t.hide_from_reports_until > current_date as gray_symbol
from premarket_prices p inner join tickers t on p.ticker_symbol=t.symbol
where
t.scrape_data and
last_trade is not null and
last_trade > 1 and
volume is not null and
volume > 8 and
previous_close is not null and
average_volume_50day is not null and
average_volume_50day > 0 and
(((last_trade / previous_close) - 1) * 100 < -2 or ((last_trade / previous_close) - 1) * 100 > 2) and
price_date = '#{report_date.strftime('%Y-%m-%d')}'
order by volume_ratio desc
SQL
      end

    end
  end
end