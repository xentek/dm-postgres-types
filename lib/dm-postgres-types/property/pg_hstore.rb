# encoding: utf-8

require 'dm-core'

module DataMapper
  class Property
    class PgHStore < Object
      HSTORE_ESCAPED = /[,\s=>\\]/

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
        value.map do |key, val|
          "%s=>%s" % [hstore_escape(key), hstore_escape(val)]
        end * ","
      end

      private

      def hstore_escape(str)
        return "NULL" if str.nil?

        str = str.to_s.dup
        # backslash is an escape character for strings, and an escape character for gsub, so you need 6 backslashes to get 2 in the output.
        # see http://stackoverflow.com/questions/1542214/weird-backslash-substitution-in-ruby for the gory details
        str.gsub!(/\\/, '\\\\\\')
        # escape backslashes before injecting more backslashes
        str.gsub!(/"/, '\"')

        if str =~ HSTORE_ESCAPED or str.empty?
          str = '"%s"' % str
        end

        str
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
