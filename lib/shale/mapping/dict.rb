# frozen_string_literal: true

require_relative 'dict_base'
require_relative 'dict_group'

module Shale
  module Mapping
    # Mapping for dictionary serialization formats (Hash/JSON/YAML)
    #
    # @api private
    class Dict < DictBase
      # Map key to attribute
      #
      # @param [String] key Document's key
      # @param [Symbol, nil] to Object's attribute
      # @param [Hash, nil] using
      # @param [true, false] render_nil
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def map(key, to: nil, using: nil, render_nil: false)
        super(key, to: to, using: using, render_nil: render_nil)
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
