# frozen_string_literal: true

require 'rack/utils'

module Shale
  module Adapter
    # RackURLEncoded adapter. Adapter for url-encoded format using rack utils.
    #
    # @api public
    class RackURLEncoded
      # Synthetic key used to coax Rack into parsing a top-level array.
      # Rack's parser always produces a Hash at the root and refuses to treat
      # a leading "[]" as array nesting, so we prefix each pair with this key,
      # let Rack build the array under it, then unwrap the result.
      TOP_LEVEL_ARRAY_KEY = 'r'

      class << self
        # Parse x-www-form-urlencoded into Hash
        #
        # @param [String] text x-www-form-urlencoded text
        # @param [Hash] options
        #
        # @return [Hash]
        #
        # @api private
        def load(text, **_options)
          return ::Rack::Utils.parse_nested_query(text) unless top_level_array?(text)

          prefixed = text.split('&').map { |pair| "#{TOP_LEVEL_ARRAY_KEY}#{pair}" }.join('&')
          ::Rack::Utils.parse_nested_query(prefixed)[TOP_LEVEL_ARRAY_KEY]
        end

        # Serialize Hash into x-www-form-urlencoded
        #
        # @param [Hash] obj Hash object
        # @param [Hash] options
        #
        # @return [String]
        #
        # @api private
        def dump(obj, **_options)
          ::Rack::Utils.build_nested_query(obj)
        end

        private

        # Detect whether the document encodes a top-level array. Such documents
        # start with "[]" (escaped as "%5B%5D")
        #
        # @param [String] text x-www-form-urlencoded text
        #
        # @return [Boolean]
        #
        # @api private
        def top_level_array?(text)
          return false if text.nil? || text.empty?

          text.start_with?('%5B%5D')
        end
      end
    end
  end
end
