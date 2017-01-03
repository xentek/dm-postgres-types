# encoding: utf-8

require 'dm-core'
require 'dm-types/support/dirty_minder'

module DataMapper
  class Property
    class PgJSON < Object
      accept_options :load_raw_value
      attr_reader :load_raw_value
      def initialize(model, name, options = {})
        super
        @load_raw_value = @options[:load_raw_value] || false
      end

      def dump(value)
        case value
        when ::NilClass, ::String
          value
        when ::Hash, ::Array
          MultiJson.dump(value, mode: :compat)
        else
          '{}'
        end
      end

      def load(value)
        case value
        when ::Hash, ::Array
          (load_raw_value) ? MultiJson.dump(value, mode: :compat) : value
        when ::String
          (load_raw_value) ? value : MultiJson.load(value)
        else
          (load_raw_value) ? '{}' : {}
        end
      end

      def primitive?(value)
        value.kind_of?(::String)
      end
    end
  end
end
