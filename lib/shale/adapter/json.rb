# frozen_string_literal: true

require 'json'

module Shale
  module Adapter
    # JSON adapter
    #
    # @api public
    class JSON
      # Parse JSON into Hash
      #
      # @param [String] json JSON document
      # @param [Hash] options
      #
      # @return [Hash]
      #
      # @api private
      def self.load(json, **options)
        ::JSON.parse(json, **options)
      end

      # Serialize Hash into JSON
      #
      # @param [Hash] obj Hash object
      # @param [Hash] options
      #
      # @return [String]
      #
      # @api private
      def self.dump(obj, **options)
        json_options = options.except(:pretty)

        if options[:pretty]
          ::JSON.pretty_generate(obj, **json_options)
        else
          ::JSON.generate(obj, **json_options)
        end
      end
    end
  end
end
