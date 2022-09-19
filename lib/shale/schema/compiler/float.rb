# frozen_string_literal: true

module Shale
  module Schema
    module Compiler
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

        alias ruby_namespace name
      end
    end
  end
end
