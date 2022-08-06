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
      #
      # @return [Hash]
      #
      # @api private
      def self.load(json)
        ::JSON.parse(json)
      end

      # Serialize Hash into JSON
      #
      # @param [Hash] obj Hash object
      # @param [true, false] pretty
      #
      # @return [String]
      #
      # @api private
      def self.dump(obj, pretty: false)
        if pretty
          ::JSON.pretty_generate(obj)
        else
          ::JSON.generate(obj)
        end
      end
    end
  end
end
