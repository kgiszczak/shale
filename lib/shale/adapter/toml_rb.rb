# frozen_string_literal: true

require 'toml-rb'

module Shale
  module Adapter
    # TomlRB adapter
    #
    # @api public
    class TomlRB
      # Parse TOML into Hash
      #
      # @param [String] toml TOML document
      # @param [Hash] options
      #
      # @return [Hash]
      #
      # @api private
      def self.load(toml, **_options)
        ::TomlRB.parse(toml)
      end

      # Serialize Hash into TOML
      #
      # @param [Hash] obj Hash object
      # @param [Hash] options
      #
      # @return [String]
      #
      # @api private
      def self.dump(obj, **_options)
        ::TomlRB.dump(obj)
      end
    end
  end
end
