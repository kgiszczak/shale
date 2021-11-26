# frozen_string_literal: true

require_relative 'attribute'
require_relative 'error'
require_relative 'utils'
require_relative 'mapping/key_value'
require_relative 'mapping/xml'
require_relative 'type/complex'

module Shale
  class Mapper < Type::Complex
    @attributes = {}
    @hash_mapping = Mapping::KeyValue.new
    @json_mapping = Mapping::KeyValue.new
    @yaml_mapping = Mapping::KeyValue.new
    @xml_mapping = Mapping::Xml.new

    class << self
      attr_reader :attributes, :hash_mapping, :json_mapping, :yaml_mapping, :xml_mapping

      def inherited(subclass)
        super
        subclass.instance_variable_set('@attributes', @attributes.dup)

        subclass.instance_variable_set('@__hash_mapping_init', @hash_mapping.dup)
        subclass.instance_variable_set('@__json_mapping_init', @json_mapping.dup)
        subclass.instance_variable_set('@__yaml_mapping_init', @yaml_mapping.dup)
        subclass.instance_variable_set('@__xml_mapping_init', @xml_mapping.dup)

        subclass.instance_variable_set('@hash_mapping', @hash_mapping.dup)
        subclass.instance_variable_set('@json_mapping', @json_mapping.dup)
        subclass.instance_variable_set('@yaml_mapping', @yaml_mapping.dup)

        xml_mapping = @xml_mapping.dup
        xml_mapping.root(Utils.underscore(subclass.name || ''))

        subclass.instance_variable_set('@xml_mapping', xml_mapping.dup)
      end

      def attribute(name, type, collection: false, default: nil)
        name = name.to_sym

        unless default.nil? || default.respond_to?(:call)
          raise DefaultNotCallableError.new(to_s, name)
        end

        @attributes[name] = Attribute.new(name, type, collection, default)

        @hash_mapping.map(name.to_s, to: name)
        @json_mapping.map(name.to_s, to: name)
        @yaml_mapping.map(name.to_s, to: name)
        @xml_mapping.map_element(name.to_s, to: name)

        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          attr_reader name

          def #{name}=(val)
            @#{name} = #{collection} ? val : #{type}.cast(val)
          end
        RUBY
      end

      def hash(&block)
        @hash_mapping = @__hash_mapping_init.dup
        @hash_mapping.instance_eval(&block)
      end

      def json(&block)
        @json_mapping = @__json_mapping_init.dup
        @json_mapping.instance_eval(&block)
      end

      def yaml(&block)
        @yaml_mapping = @__yaml_mapping_init.dup
        @yaml_mapping.instance_eval(&block)
      end

      def xml(&block)
        @xml_mapping = @__xml_mapping_init.dup
        @xml_mapping.instance_eval(&block)
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
