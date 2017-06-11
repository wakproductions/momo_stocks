class RenameSymbolToTickerSymbol < ActiveRecord::Migration[5.1]
  def change
    rename_column :report_line_items, :symbol, :ticker_symbol
  end
end
