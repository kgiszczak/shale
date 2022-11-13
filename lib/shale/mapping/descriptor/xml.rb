# frozen_string_literal: true

require_relative 'dict'

module Shale
  module Mapping
    module Descriptor
      # Class representing XML attribute mapping
      #
      # @api private
      class Xml < Dict
        # Return namespace
        #
        # @return [String]
        #
        # @api private
        attr_reader :namespace

        # Return cdata
        #
        # @return [true, false]
        #
        # @api private
        attr_reader :cdata

        # Initialize instance
        #
        # @param [String] name
        # @param [Symbol, nil] attribute
        # @param [Symbol, nil] receiver
        # @param [Hash, nil] methods
        # @param [String, nil] group
        # @param [Shale::Mapping::XmlNamespace] namespace
        # @param [true, false] cdata
        # @param [true, false] render_nil
        #
        # @api private
        def initialize(
          name:,
          attribute:,
          receiver:,
          methods:,
          group:,
          namespace:,
          cdata:,
          render_nil:
        )
          super(
            name: name,
            attribute: attribute,
            receiver: receiver,
            methods: methods,
            group: group,
            render_nil: render_nil
          )

          @namespace = namespace
          @cdata = cdata
        end

        # Return name with XML prefix
        #
        # @return [String]
        #
        # @api private
        def prefixed_name
          [namespace.prefix, name].compact.join(':')
        end

        # Return name with XML namespace
        #
        # @return [String]
        #
        # @api private
        def namespaced_name
          [namespace.name, name].compact.join(':')
        end
      end
    end
  end
end
