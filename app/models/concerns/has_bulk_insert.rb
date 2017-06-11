module HasBulkInsert
  extend ActiveSupport::Concern

  included do
  end

  class_methods do
    BI_IGNORE_COLUMNS=%w(id)

    def bulk_insert(values_array)
      return if values_array.empty?
      ActiveRecord::Base.connection.execute bi_sql(values_array)
    end

    protected
    def bi_column_definitions
      self
        .columns_hash
        .map {|col,props| BI_IGNORE_COLUMNS.include?(col) ? nil : {col=>props.type} }
        .compact
        .reduce({}, :merge)
    end

    def bi_escaped_column_names
      bi_column_definitions.reduce([]) { |m,(k,v)| m << "#{k}" }.join(',')
    end

    def bi_sql(values_array)
      <<SQL
INSERT INTO #{self.table_name} (#{bi_escaped_column_names}) VALUES
#{bi_convert_values_array(values_array)};
SQL
    end

    def bi_convert_values_array(values_array)
      values_array.map do |values_hash|
        line_values = bi_column_definitions.reduce([]) do |line, (col,definition)|
          vh = values_hash.stringify_keys

          next line << 'NULL' if vh[col].nil? && !is_timestamp_column?(col)

          case definition
            when :string, :text
              if is_enum_column?(col)
                line << "'#{enum_value(col, vh[col])}'"
              else
                line << "'#{vh[col].gsub("'", "''")}'"
              end
            when :date
              line << "'#{vh[col].strftime('%Y-%m-%d')}'"
            when :datetime
              if is_timestamp_column?(col)
                line << "'#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}'"
              else
                line << "'#{vh[col].strftime('%Y-%m-%d')}'"
              end
            when :integer
              if vh[col].is_a? Integer
                line << vh[col].to_s
              elsif vh[col].is_a?(String) && is_enum_column?(col)
                line << "'#{enum_value(col, vh[col])}'"
              else
                raise "Unable to interpret data for column #{col}\n#{vh}"
              end
            when :decimal, :boolean, :float
              line << vh[col].to_s
            else
              raise "Unknown data column type: #{definition}"
          end
        end
          .join(',')

        "(#{line_values})"
      end
        .join(",\n")
    end

    def enum_value(column_name, enumeration_value)
      self.send(column_name.pluralize)[enumeration_value]
    end

    def is_enum_column?(column_name)
      self.defined_enums.include?(column_name)
    end

    def is_timestamp_column?(column_name)
      %w(created_at updated_at).include?(column_name)
    end
  end
end