# frozen_string_literal: true

module Shale
  module Mapping
    module Descriptor
      # Class representing XML namespace
      #
      # @api private
      class XmlNamespace
        # Return name
        #
        # @return [String]
        #
        # @api private
        attr_accessor :name

        # Return prefix
        #
        # @return [String]
        #
        # @api private
        attr_accessor :prefix

        # Initialize instance
        #
        # @param [String, nil] name
        # @param [String, nil] prefix
        #
        # @api private
        def initialize(name = nil, prefix = nil)
          @name = name
          @prefix = prefix
        end
      end
    end
  end
end
