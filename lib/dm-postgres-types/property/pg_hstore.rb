# encoding: utf-8

require 'dm-core'

module DataMapper
  class Property
    class PgHStore < Object
      def load(value)
        return nil unless value
        values = value.split(",")
        values.map! { |val| unescape_pg_hash(val) }
        values.map! { |key, val| [key, unescape_nil(val)] }
        Hash[*(values.flatten)]
      end

      def dump(value)
        return "" unless value
        value.map! do |idx, val|
          [escape_double_quote(idx), escape_value(val)].join(",")
        end
      end

      private

      def escape_nil(value)
        (value.nil?) ? 'NULL' : value
      end

      def unescape_nil(value)
        (value == 'NULL') ? nil : value
      end

      def escape_double_quote(value)
        value.gsub!(/"/, '\"')
        value
      end

      def unescape_double_quote(value)
        value.gsub!('"','')
        value.strip!
        value
      end

      def escape_pg_hash(value)
        (value =~ /[,\s=>]/ || value.empty?) ? %Q{"#{value}"} : value
      end

      def unescape_pg_hash(value)
        values = value.split("=>")
        values.map! { |val| unescape_double_quote(val) }
        values
      end

      def escape_value(value)
        escape_double_quote(escape_nil(escape_pg_hash(value)))
      end
    end
  end
end
