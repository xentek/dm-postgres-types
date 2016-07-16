# encoding: utf-8

require 'dm-core'

module DataMapper
  class Property
    class PgHStore < Object
      def load(value)
        return nil unless value
        values = value.split(", ")
        values.map! do |val|
          k, v = val.split("=>")
          [unescape_double_quote(k),unescape_double_quote(unescape_nil(v))]
        end
        Hash[*(values.flatten)]
      end

      def dump(value)
        return "" unless value
        value.map { |key, val| %Q{"#{key.to_s}"=>"#{escape(val)}"} }.join(", ")
      end

      private

      def escape(value)
        escape_nil(value).to_s.gsub("\\", "\\\\\\\\")
      end

      def escape_nil(value)
        (value.nil?) ? 'NULL' : value
      end

      def unescape_nil(value)
        (value == 'NULL') ? nil : value
      end

      def unescape_double_quote(value)
        value.gsub!('"','') if value.respond_to?(:gsub!)
        value.strip! if value.respond_to?(:strip!)
        value
      end
    end
  end
end
