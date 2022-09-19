# frozen_string_literal: true

module Shale
  module Schema
    module Compiler
      # Class that maps Schema type to Shale String type
      #
      # @api private
      class String
        # Return name of the Shale type
        #
        # @return [String]
        #
        # @api private
        def name
          'Shale::Type::String'
        end

        alias ruby_class_name name
      end
    end
  end
end
