# frozen_string_literal: true

require_relative '../error'

module Shale
  module Mapping
    module Validator
      # Validate correctness of argument passed to map functions
      #
      # @param [String] key
      # @param [Symbol, nil] to
      # @param [Symbol, nil] receiver
      # @param [Hash, nil] using
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def self.validate_arguments(key, to, receiver, using)
        if to.nil? && using.nil?
          msg = ":to or :using argument is required for mapping '#{key}'"
          raise IncorrectMappingArgumentsError, msg
        end

        if to.nil? && !receiver.nil?
          msg = ":receiver argument for mapping '#{key}' " \
                'can only be used together with :to argument'
          raise IncorrectMappingArgumentsError, msg
        end

        if !using.nil? && (using[:from].nil? || using[:to].nil?)
          msg = ":using argument for mapping '#{key}' requires :to and :from keys"
          raise IncorrectMappingArgumentsError, msg
        end
      end

      # Validate correctness of namespace arguments
      #
      # @param [String] key
      # @param [String, Symbol, nil] namespace
      # @param [String, Symbol, nil] prefix
      #
      # @raise [IncorrectMappingArgumentsError] when arguments are incorrect
      #
      # @api private
      def self.validate_namespace(key, namespace, prefix)
        return if namespace == :undefined && prefix == :undefined

        nsp = namespace == :undefined ? nil : namespace
        pfx = prefix == :undefined ? nil : prefix

        if (nsp && !pfx) || (!nsp && pfx)
          msg = "both :namespace and :prefix arguments are required for mapping '#{key}'"
          raise IncorrectMappingArgumentsError, msg
        end
      end
    end
  end
end
