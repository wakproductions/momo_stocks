def load_ticker_icon_category_list
  return $ticker_icon_categories = {} unless ActiveRecord::Base.connection.data_source_exists? 'tickers'

  biotech = Ticker.all.select(:symbol).where(
    industry:
      [
        "Biotechnology: Electromedical & Electrotherapeutic Apparatus",
        "Biotechnology: Biological Products (No Diagnostic Substances)",
      ]
  ).pluck(:symbol)
  pharma = Ticker.all.select(:symbol).where(industry: "Major Pharmaceuticals").pluck(:symbol)

  ticker_hash = {}
  biotech.each { |symbol| ticker_hash[symbol] = 'stock-icon-biotech.png' }
  pharma.each { |symbol| ticker_hash[symbol] = 'stock-icon-majorpharma.png' }

  $ticker_icon_categories = ticker_hash
end

load_ticker_icon_category_list
