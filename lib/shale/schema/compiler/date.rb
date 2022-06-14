# frozen_string_literal: true

module Shale
  module Schema
    module Compiler
      # Class that maps Schema type to Shale Date type
      #
      # @api private
      class Date
        # Return name of the Shale type
        #
        # @return [String]
        #
        # @api private
        def name
          'Shale::Type::Date'
        end
      end
    end
  end
end
