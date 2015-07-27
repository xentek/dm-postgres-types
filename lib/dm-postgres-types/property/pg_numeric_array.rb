# encoding: utf-8

require 'dm-core'
require 'dm-postgres-types/property/pg_array'

module DataMapper
  class Property
    class PgNumericArray < PgArray
      accept_options :precision, :scale
      attr_reader :precision, :scale

      def initialize(model, name, options = {})
        super
        @precision = @options[:precision] || 10
        @scale     = @options[:scale]     || 0

        if precision <= 0
          raise ArgumentError, "precision must be greater than 0"
        end

        if scale < 0
          raise ArgumentError, "scale must be greater than or equal to 0"
        end        
      end

      def load(value)
        values = super
        values.map! { |val| (scale > 0) ? val.to_f : val.to_i } if values
        values
      end
    end
  end
end
