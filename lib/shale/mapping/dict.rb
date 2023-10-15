# frozen_string_literal: true

require_relative 'dict_base'
require_relative 'dict_group'

module Shale
  module Mapping
    # Mapping for dictionary serialization formats (Hash/JSON/YAML/TOML/CSV)
    #
    # @api private
    class Dict < DictBase
      # Map key to attribute
      #
      # @param [String] key Document's key
      # @param [Symbol, nil] to
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      # @param [true, false, nil] render_nil
      # @param [Hash, nil] schema
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api public
      def map(key, to: nil, receiver: nil, using: nil, render_nil: nil, schema: nil)
        super(key, to: to, receiver: receiver, using: using, render_nil: render_nil, schema: schema)
      end

      # Set render_nil default
      #
      # @param [true, false] val
      #
      # @api private
      def render_nil(val)
        @render_nil_default = val
      end

      # Map group of keys to mapping methods
      #
      # @param [Symbol] from
      # @param [Symbol] to
      # @param [Proc] block
      #
      # @api private
      def group(from:, to:, &block)
        group = DictGroup.new(from, to)
        group.instance_eval(&block)
        @keys.merge!(group.keys)
      end
    end
  end
end
