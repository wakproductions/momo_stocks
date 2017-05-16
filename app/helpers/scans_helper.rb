module ScansHelper
  RJUST_FIELDS=[:last_trade, :pct_change, :pct_above_52, :gap_percent, :float, :float_percent, :institutional_ownership_percent, :volume, :volume_ratio, :average_volume, :short_ratio]

  def report_date_form(page)
    s = form_tag "/reports/#{page}", method: :get, authenticity_token: false do
      b = text_field_tag :report_date, @report_date.strftime('%m/%d/%Y')
      b << submit_tag("Go")
      b
    end
    s.html_safe
  end

  def set_vix_contango_style(contango_percent)
    "background-color: red" if contango_percent < 1
  end

  # TODO move this method into the presenter
  def set_css_class(report, field)
    css_class = "monospaced "
    if report[:pct_change].to_f > 0
      css_class << "green "
    elsif report[:pct_change].to_f < 0
      css_class << "red "
    end

    if report[:gap_pct].to_f > 0
      css_class << "green "
    elsif report[:gap_pct].to_f < 0
      css_class << "red "
    end

    if report[:pct_above_52].to_f > 0
      css_class << "green "
    elsif report[:pct_above_52].to_f < 0
      css_class << "red "
    end

    css_class << "rjust " if RJUST_FIELDS.include?(field)

    case field
      when :pct_above_52
        if report[:pct_above_52].to_f > 5.0
          css_class << "darkgreen-bg  "
        end

        if report[:pct_above_52].to_f.abs > 7.5
          css_class << "bold "
        end

      when :pct_change
        if report[:pct_change].to_f < -7.5
          css_class << "darkred-bg  "
        elsif report[:pct_change].to_f > 7.5
          css_class << "darkgreen-bg  "
        end

        if report[:pct_change].to_f.abs > 10
          css_class << "bold "
        end
      when :gap_percent
        if report[:gap_pct].to_f < -7.5
          css_class << "darkred-bg  "
        elsif report[:gap_pct].to_f > 7.5
          css_class << "darkgreen-bg  "
        end

        if report[:gap_pct].to_f.abs > 10
          css_class << "bold "
        end
      when :float
        # Format how it is displayed into millions from thousands of shares
        report[:float] = '%.0f' % (report[:float] / 1000).truncate(2) if report[:float].present?

        if (report[:float].to_f < 15 && (report[:float].to_f) > 0)
          css_class << 'gold-bg '
        end
      when :float_pct
        
      when :volume_ratio then css_class << "yellow-bg " if (report[:volume_ratio].to_f > 3)
      when :range then css_class << "yellow-bg " if (report[:range].to_f > 7)
      when :unscrape then css_class << "clickable "

    end

    css_class.strip
  end

  def symbol_icon(symbol)
    image = $ticker_icon_categories[symbol]
    if image
      image_tag(asset_path(image), class: 'report-stock-icon')
    else
      ''
    end
  end
end
