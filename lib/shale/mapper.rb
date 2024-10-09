# frozen_string_literal: true

require_relative 'attribute'
require_relative 'error'
require_relative 'utils'
require_relative 'mapping/dict'
require_relative 'mapping/xml'
require_relative 'type'
require_relative 'type/complex'

module Shale
  # Base class used for mapping
  #
  # @example
  #   class Address < Shale::Mapper
  #     attribute :city, :string
  #     attribute :street, :string
  #     attribute :state, :string
  #     attribute :zip, :string
  #   end
  #
  #   class Person < Shale::Mapper
  #     attribute :first_name, :string
  #     attribute :last_name, :string
  #     attribute :age, :integer
  #     attribute :address, Address
  #   end
  #
  #   person = Person.from_json(%{
  #     {
  #       "first_name": "John",
  #       "last_name": "Doe",
  #       "age": 55,
  #       "address": {
  #         "city": "London",
  #         "street": "Oxford Street",
  #         "state": "London",
  #         "zip": "E1 6AN"
  #       }
  #     }
  #   })
  #
  #   person.to_json
  #
  # @api public
  class Mapper < Type::Complex
    @model = nil
    @attributes = {}
    @hash_mapping = Mapping::Dict.new
    @json_mapping = Mapping::Dict.new
    @yaml_mapping = Mapping::Dict.new
    @toml_mapping = Mapping::Dict.new
    @csv_mapping = Mapping::Dict.new(render_nil_default: true)
    @xml_mapping = Mapping::Xml.new

    class << self
      # Return attributes Hash
      #
      # @return [Hash<Symbol, Shale::Attribute>]
      #
      # @api public
      attr_reader :attributes

      # Return Hash mapping object
      #
      # @return [Shale::Mapping::Dict]
      #
      # @api public
      attr_reader :hash_mapping

      # Return JSON mapping object
      #
      # @return [Shale::Mapping::Dict]
      #
      # @api public
      attr_reader :json_mapping

      # Return YAML mapping object
      #
      # @return [Shale::Mapping::Dict]
      #
      # @api public
      attr_reader :yaml_mapping

      # Return TOML mapping object
      #
      # @return [Shale::Mapping::Dict]
      #
      # @api public
      attr_reader :toml_mapping

      # Return CSV mapping object
      #
      # @return [Shale::Mapping::Dict]
      #
      # @api public
      attr_reader :csv_mapping

      # Return XML mapping object
      #
      # @return [Shale::Mapping::XML]
      #
      # @api public
      attr_reader :xml_mapping

      # @api private
      def inherited(subclass)
        super

        attributes_module = Module.new
        subclass.instance_variable_set('@attributes_module', attributes_module)
        subclass.include(attributes_module)

        subclass.instance_variable_set('@model', subclass)
        subclass.instance_variable_set('@attributes', @attributes.dup)

        subclass.instance_variable_set('@__hash_mapping_init', @hash_mapping.dup)
        subclass.instance_variable_set('@__json_mapping_init', @json_mapping.dup)
        subclass.instance_variable_set('@__yaml_mapping_init', @yaml_mapping.dup)
        subclass.instance_variable_set('@__toml_mapping_init', @toml_mapping.dup)
        subclass.instance_variable_set('@__csv_mapping_init', @csv_mapping.dup)
        subclass.instance_variable_set('@__xml_mapping_init', @xml_mapping.dup)

        subclass.instance_variable_set('@hash_mapping', @hash_mapping.dup)
        subclass.instance_variable_set('@json_mapping', @json_mapping.dup)
        subclass.instance_variable_set('@yaml_mapping', @yaml_mapping.dup)
        subclass.instance_variable_set('@toml_mapping', @toml_mapping.dup)
        subclass.instance_variable_set('@csv_mapping', @csv_mapping.dup)

        xml_mapping = @xml_mapping.dup
        xml_mapping.root(Utils.underscore(subclass.name || ''))

        subclass.instance_variable_set('@xml_mapping', xml_mapping.dup)
      end

      def model(klass = nil)
        if klass
          @model = klass
          xml_mapping.root(Utils.underscore(@model.name))
        else
          @model
        end
      end

      # Define attribute on class
      #
      # @param [Symbol] name Name of the attribute
      # @param [Symbol, Class<Shale::Type::Value>] type Type of the attribute
      # @param [Boolean] collection Is the attribute a collection
      # @param [Proc] default Default value for the attribute
      #
      # @raise [DefaultNotCallableError] when attribute's default is not callable
      # @raise [UnknownTypeError] when type is a symbol and not found in the registry
      #
      # @example
      #   class Person < Shale::Mapper
      #     attribute :first_name, :string
      #     attribute :last_name, :string
      #     attribute :age, :integer, default: -> { 1 }
      #     attribute :hobbies, :string, collection: true
      #   end
      #
      #   person = Person.new
      #
      #   person.first_name # => nil
      #   person.first_name = 'John'
      #   person.first_name # => 'John'
      #
      #   person.age # => 1
      #
      #   person.hobbies << 'Dancing'
      #   person.hobbies # => ['Dancing']
      #
      # @api public
      def attribute(name, type, collection: false, default: nil)
        name = name.to_sym

        unless default.nil? || default.respond_to?(:call)
          raise DefaultNotCallableError.new(to_s, name)
        end

        if type.is_a?(Symbol)
          type = Type.lookup(type)
        end

        @attributes[name] = Attribute.new(name, type, collection, default)

        @hash_mapping.map(name.to_s, to: name) unless @hash_mapping.finalized?
        @json_mapping.map(name.to_s, to: name) unless @json_mapping.finalized?
        @yaml_mapping.map(name.to_s, to: name) unless @yaml_mapping.finalized?
        @toml_mapping.map(name.to_s, to: name) unless @toml_mapping.finalized?
        @csv_mapping.map(name.to_s, to: name) unless @csv_mapping.finalized?
        @xml_mapping.map_element(name.to_s, to: name) unless @xml_mapping.finalized?

        @attributes_module.class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          attr_reader :#{name}

          def #{name}=(val)
            @#{name} = #{collection} ? val : #{type}.cast(val)
          end
        RUBY
      end

      # Define Hash mapping
      #
      # @param [Proc] block
      #
      # @example
      #   class Person < Shale::Mapper
      #     attribute :first_name, :string
      #     attribute :last_name, :string
      #     attribute :age, :integer
      #
      #     hsh do
      #       map 'firstName', to: :first_name
      #       map 'lastName', to: :last_name
      #       map 'age', to: :age
      #     end
      #   end
      #
      # @api public
      def hsh(&block)
        @hash_mapping = @__hash_mapping_init.dup
        @hash_mapping.finalize!
        @hash_mapping.instance_eval(&block)
      end

      # Define JSON mapping
      #
      # @param [Proc] block
      #
      # @example
      #   class Person < Shale::Mapper
      #     attribute :first_name, :string
      #     attribute :last_name, :string
      #     attribute :age, :integer
      #
      #     json do
      #       map 'firstName', to: :first_name
      #       map 'lastName', to: :last_name
      #       map 'age', to: :age
      #     end
      #   end
      #
      # @api public
      def json(&block)
        @json_mapping = @__json_mapping_init.dup
        @json_mapping.finalize!
        @json_mapping.instance_eval(&block)
      end

      # Define YAML mapping
      #
      # @param [Proc] block
      #
      # @example
      #   class Person < Shale::Mapper
      #     attribute :first_name, :string
      #     attribute :last_name, :string
      #     attribute :age, :integer
      #
      #     yaml do
      #       map 'first_name', to: :first_name
      #       map 'last_name', to: :last_name
      #       map 'age', to: :age
      #     end
      #   end
      #
      # @api public
      def yaml(&block)
        @yaml_mapping = @__yaml_mapping_init.dup
        @yaml_mapping.finalize!
        @yaml_mapping.instance_eval(&block)
      end

      # Define TOML mapping
      #
      # @param [Proc] block
      #
      # @example
      #   class Person < Shale::Mapper
      #     attribute :first_name, :string
      #     attribute :last_name, :string
      #     attribute :age, :integer
      #
      #     toml do
      #       map 'first_name', to: :first_name
      #       map 'last_name', to: :last_name
      #       map 'age', to: :age
      #     end
      #   end
      #
      # @api public
      def toml(&block)
        @toml_mapping = @__toml_mapping_init.dup
        @toml_mapping.finalize!
        @toml_mapping.instance_eval(&block)
      end

      # Define CSV mapping
      #
      # @param [Proc] block
      #
      # @example
      #   class Person < Shale::Mapper
      #     attribute :first_name, :string
      #     attribute :last_name, :string
      #     attribute :age, :integer
      #
      #     csv do
      #       map 'first_name', to: :first_name
      #       map 'last_name', to: :last_name
      #       map 'age', to: :age
      #     end
      #   end
      #
      # @api public
      def csv(&block)
        @csv_mapping = @__csv_mapping_init.dup
        @csv_mapping.finalize!
        @csv_mapping.instance_eval(&block)
      end

      # Define XML mapping
      #
      # @param [Proc] block
      #
      # @example
      #   class Person < Shale::Mapper
      #     attribute :first_name, :string
      #     attribute :last_name, :string
      #     attribute :age, :integer
      #
      #     xml do
      #       root 'Person'
      #       map_content to: :first_name
      #       map_element 'LastName', to: :last_name
      #       map_attribute 'age', to: :age
      #     end
      #   end
      #
      # @api public
      def xml(&block)
        @xml_mapping = @__xml_mapping_init.dup
        @xml_mapping.finalize!
        @xml_mapping.root('')
        @xml_mapping.instance_eval(&block)
      end
    end

    # Initialize instance with properties
    #
    # @param [Hash] props Properties
    #
    # @raise [UnknownAttributeError] when attribute is not defined on the class
    #
    # @example
    #   Person.new(
    #     first_name: 'John',
    #     last_name: 'Doe',
    #     address: Address.new(city: 'London')
    #   )
    #   # => #<Person:0x00007f82768a2370
    #           @first_name="John",
    #           @last_name="Doe"
    #           @address=#<Address:0x00007fe9cf0f57d8 @city="London">>
    #
    # @api public
    def initialize(**props)
      super()

      unless props.empty?
        unknown_attributes = props.keys - self.class.attributes.keys

        unless unknown_attributes.empty?
          raise UnknownAttributeError.new(self.class.to_s, unknown_attributes[0].to_s)
        end
      end

      self.class.attributes.each do |name, attribute|
        if props.key?(name)
          value = props[name]
        elsif attribute.default
          value = attribute.default.call
        end

        send(attribute.setter, value)
      end
    end
  end
end
