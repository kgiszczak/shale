# frozen_string_literal: true

require 'tomlib'

module Shale
  module Adapter
    # Tomlib adapter
    #
    # @api public
    class Tomlib
      # Parse TOML into Hash
      #
      # @param [String] toml TOML document
      # @param [Hash] options
      #
      # @return [Hash]
      #
      # @api private
      def self.load(toml, **_options)
        ::Tomlib.load(toml)
      end

      # Serialize Hash into TOML
      #
      # @param [Hash] obj Hash object
      # @param [Hash] options
      #
      # @return [String]
      #
      # @api private
      def self.dump(obj, **options)
        ::Tomlib.dump(obj, **options)
      end
    end
  end
end
