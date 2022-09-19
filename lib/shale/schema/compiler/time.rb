# frozen_string_literal: true

module Shale
  module Schema
    module Compiler
      # Class that maps Schema type to Shale Time type
      #
      # @api private
      class Time
        # Return name of the Shale type
        #
        # @return [String]
        #
        # @api private
        def name
          'Shale::Type::Time'
        end

        alias ruby_class_name name
      end
    end
  end
end
