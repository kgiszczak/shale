# frozen_string_literal: true

require_relative 'attribute'
require_relative 'error'
require_relative 'mapping'
require_relative 'type/complex'

module Shale
  class Mapper < Type::Complex
    @attributes = {}
    @hash_mapping = Mapping.new
    @json_mapping = Mapping.new
    @yaml_mapping = Mapping.new

    class << self
      attr_reader :attributes, :hash_mapping, :json_mapping, :yaml_mapping

      def inherited(subclass)
        subclass.instance_variable_set('@attributes', @attributes.dup)
        subclass.instance_variable_set('@hash_mapping', @hash_mapping.dup)
        subclass.instance_variable_set('@json_mapping', @json_mapping.dup)
        subclass.instance_variable_set('@yaml_mapping', @yaml_mapping.dup)
      end

      def attribute(name, type, collection: false, default: nil)
        name = name.to_sym

        unless default.nil? || default.respond_to?(:call)
          raise DefaultNotCallableError.new(self.to_s, name)
        end

        @attributes[name] = Attribute.new(name, type, collection, default)

        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          attr_reader name

          def #{name}=(val)
            @#{name} = #{collection} ? val : #{type}.cast(val)
          end
        RUBY
      end

      def hash(&block)
        @hash_mapping.instance_eval(&block)
      end

      def json(&block)
        @json_mapping.instance_eval(&block)
      end

      def yaml(&block)
        @yaml_mapping.instance_eval(&block)
      end
    end

    def initialize(**props)
      super()

      props.each_key do |name|
        unless self.class.attributes.keys.include?(name)
          raise UnknownAttributeError.new(self.class.to_s, name.to_s)
        end
      end

      self.class.attributes.each do |name, attribute|
        if props.key?(name)
          value = props[name]
        elsif attribute.default
          value = attribute.default.call
        end

        public_send("#{name}=", value)
      end
    end
  end
end
