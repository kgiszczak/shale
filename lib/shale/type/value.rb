# frozen_string_literal: true

module Shale
  module Type
    # Base class for all types
    #
    # @example
    #   class MyType < Shale::Type::Value
    #     ... overwrite methods as needed
    #   end
    #
    # @api public
    class Value
      class << self
        # Cast raw value to a type. Base form just returns whatever it receives
        #
        # @param [any] value Value to cast
        #
        # @return [any]
        #
        # @api private
        def cast(value)
          value
        end

        # Extract value from Hash document
        #
        # @param [any] value
        #
        # @return [any]
        #
        # @api private
        def of_hash(value)
          value
        end

        # Convert value to form accepted by Hash document
        #
        # @param [any] value
        #
        # @return [any]
        #
        # @api private
        def as_hash(value)
          value
        end

        # Extract value from JSON document
        #
        # @param [any] value
        #
        # @return [any]
        #
        # @api private
        def of_json(value)
          value
        end

        # Convert value to form accepted by JSON document
        #
        # @param [any] value
        #
        # @return [any]
        #
        # @api private
        def as_json(value)
          value
        end

        # Extract value from YAML document
        #
        # @param [any] value
        #
        # @return [any]
        #
        # @api private
        def of_yaml(value)
          value
        end

        # Convert value to form accepted by YAML document
        #
        # @param [any] value
        #
        # @return [any]
        #
        # @api private
        def as_yaml(value)
          value
        end

        # Extract value from XML document
        #
        # @param [Shale::Adapter::<XML adapter>::Node] value
        #
        # @return [String]
        #
        # @api private
        def of_xml(node)
          node.text
        end

        # Convert value to form accepted by XML document
        #
        # @param [#to_s] value Value to convert to XML
        # @param [String] name Name of the element
        # @param [Shale::Adapter::<XML adapter>::Document] doc Document
        #
        # @api private
        def as_xml(value, name, doc)
          element = doc.create_element(name)
          doc.add_text(element, value.to_s)
          element
        end
      end
    end
  end
end
