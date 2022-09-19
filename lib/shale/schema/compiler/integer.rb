# frozen_string_literal: true

module Shale
  module Schema
    module Compiler
      # Class that maps Schema type to Shale Integer type
      #
      # @api private
      class Integer
        # Return name of the Shale type
        #
        # @return [String]
        #
        # @api private
        def name
          'Shale::Type::Integer'
        end

        alias ruby_class_name name
      end
    end
  end
end
