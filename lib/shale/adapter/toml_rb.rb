# frozen_string_literal: true

require 'toml-rb'

module Shale
  module Adapter
    # TOML adapter
    #
    # @api public
    class TomlRB
      # Parse TOML into Hash
      #
      # @param [String] toml TOML document
      #
      # @return [Hash]
      #
      # @api private
      def self.load(toml)
        ::TomlRB.parse(toml)
      end

      # Serialize Hash into TOML
      #
      # @param [Hash] obj Hash object
      #
      # @return [String]
      #
      # @api private
      def self.dump(obj)
        ::TomlRB.dump(obj)
      end
    end
  end
end
