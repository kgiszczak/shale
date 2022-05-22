# frozen_string_literal: true

module Shale
  module Schema
    class JSONCompiler
      # Class that maps Schema type to Shale Float type
      #
      # @api private
      class Float
        # Return name of the Shale type
        #
        # @return [String]
        #
        # @api private
        def name
          'Shale::Type::Float'
        end
      end
    end
  end
end
