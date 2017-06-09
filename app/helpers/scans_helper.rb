module ScansHelper
  RJUST_FIELDS=[
    :change_percent,
    :pct_above_52,
    :float,
    :float_percent_traded,
    :gap_percent,
    :institutional_ownership_percent,
    :last_trade,
    :short_days_to_cover,
    :short_percent_of_float,
    :volume,
    :volume_average,
    :volume_average_permarket,
    :volume_ratio,
  ]

  def report_date_form(page)
    s = form_tag "/reports/#{page}", method: :get, authenticity_token: false do
      b = text_field_tag :report_date, @report_date.strftime('%m/%d/%Y')
      b << submit_tag("Go")
      b
    end
    s.html_safe
  end

  def set_css_class(report, field)
    css_class = "monospaced "
    if report[:change_percent].to_f > 0
      css_class << "green "
    elsif report[:change_percent].to_f < 0
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
      when :change_percent
        if report[:change_percent].to_f < -7.5
          css_class << "darkred-bg  "
        elsif report[:change_percent].to_f > 7.5
          css_class << "darkgreen-bg  "
        end

        if report[:change_percent].to_f.abs > 10
          css_class << "bold "
        end
      when :pct_above_52
        if report[:pct_above_52].to_f > 5.0
          css_class << "darkgreen-bg  "
        end

        if report[:pct_above_52].to_f.abs > 7.5
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
      when :float_percent_traded
        
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
