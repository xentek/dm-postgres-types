# encoding: utf-8

require 'dm-core'
require 'dm-postgres-types/property/pg_array'

module DataMapper
  class Property
    class PgIntegerArray < PgArray
      def initialize(model, name, options = {})
        super
      end

      def load(value)
        values = super
        values.map! { |val| val.to_i } if values
        values
      end
    end
  end
end
