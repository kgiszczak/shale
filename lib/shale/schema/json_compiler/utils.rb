# frozen_string_literal: true

module Shale
  module Schema
    class JSONCompiler
      # Module with utility functions
      #
      # @api private
      module Utils
        # Convert string to Ruby's class naming convention
        #
        # @param [String] val
        #
        # @example
        #   Shale::Schema::JSONCompiler.classify('foobar')
        #   # => 'Foobar'
        #
        # @api private
        def self.classify(str)
          str = str.to_s.sub(/.*\./, '')

          str = str.sub(/^[a-z\d]*/) { |match| match.capitalize || match }

          str.gsub(%r{(?:_|(/))([a-z\d]*)}i) do
            word = Regexp.last_match(2)
            substituted = word.capitalize || word
            Regexp.last_match(1) ? "::#{substituted}" : substituted
          end
        end

        # Convert string to snake case
        #
        # @param [String] val
        #
        # @example
        #   Shale::Schema::JSONCompiler.snake_case('FooBar')
        #   # => 'foo_bar'
        #
        # @api private
        def self.snake_case(str)
          return str.to_s unless /[A-Z-]|::/.match?(str)
          word = str.to_s.gsub('::', '/')
          word = word.gsub(/([A-Z]+)(?=[A-Z][a-z])|([a-z\d])(?=[A-Z])/) do
            "#{Regexp.last_match(1) || Regexp.last_match(2)}_"
          end
          word = word.tr('-', '_')
          word.downcase
        end
      end
    end
  end
end
