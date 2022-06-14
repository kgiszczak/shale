# frozen_string_literal: true

module Shale
  module Schema
    module Compiler
      # Class that maps Schema type to Shale Value type
      #
      # @api private
      class Value
        # Return name of the Shale type
        #
        # @return [String]
        #
        # @api private
        def name
          'Shale::Type::Value'
        end
      end
    end
  end
end
