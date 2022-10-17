# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'tomlib'

module ShaleComplexTesting
  class ComplexType < Shale::Mapper
    attribute :complex_attr1, Shale::Type::String

    hsh do
      map 'complex_attr1', to: :complex_attr1
    end

    json do
      map 'complex_attr1', to: :complex_attr1
    end

    yaml do
      map 'complex_attr1', to: :complex_attr1
    end

    toml do
      map 'complex_attr1', to: :complex_attr1
    end

    xml do
      root 'complex_type'
      map_content to: :complex_attr1
    end
  end

  class ElementNamespaced < Shale::Mapper
    attribute :attr1, Shale::Type::String
    attribute :ns1_attr1, Shale::Type::String
    attribute :ns2_attr1, Shale::Type::String
    attribute :not_namespaced, Shale::Type::String
    attribute :ns1_one, Shale::Type::String
    attribute :ns2_one, Shale::Type::String

    xml do
      root 'element_namespaced'
      namespace 'http://ns1.com', 'ns1'

      map_attribute 'attr1', to: :attr1
      map_attribute 'attr1', to: :ns1_attr1, namespace: 'http://ns1.com', prefix: 'ns1'
      map_attribute 'attr1', to: :ns2_attr1, namespace: 'http://ns2.com', prefix: 'ns2'
      map_element 'not_namespaced', to: :not_namespaced, namespace: nil, prefix: nil
      map_element 'one', to: :ns1_one
      map_element 'one', to: :ns2_one, namespace: 'http://ns2.com', prefix: 'ns2'
    end
  end

  class RootType < Shale::Mapper
    attribute :root_attr1, Shale::Type::String
    attribute :root_attr2, Shale::Type::String, collection: true
    attribute :root_attr3, Shale::Type::String
    attribute :root_bool, Shale::Type::Boolean
    attribute :root_collection, Shale::Type::String, collection: true
    attribute :root_attr_complex, ComplexType
    attribute :root_attr_using, Shale::Type::String
    attribute :root_attr_attribute_using, Shale::Type::String
    attribute :element_namespaced, ElementNamespaced

    hsh do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_complex', to: :root_attr_complex
      map 'root_attr_using', using: {
        from: :root_attr_using_from_hash,
        to: :root_attr_using_to_hash,
      }
    end

    json do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_complex', to: :root_attr_complex
      map 'root_attr_using', using: {
        from: :root_attr_using_from_json,
        to: :root_attr_using_to_json,
      }
    end

    yaml do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_complex', to: :root_attr_complex
      map 'root_attr_using', using: {
        from: :root_attr_using_from_yaml,
        to: :root_attr_using_to_yaml,
      }
    end

    toml do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_complex', to: :root_attr_complex
      map 'root_attr_using', using: {
        from: :root_attr_using_from_toml,
        to: :root_attr_using_to_toml,
      }
    end

    xml do
      root 'root_type'
      map_attribute 'attr1', to: :root_attr1
      map_attribute 'collection', to: :root_collection
      map_attribute 'attribute_using', using: {
        from: :root_attr_attribute_using_from_xml,
        to: :root_attr_attribute_using_to_xml,
      }
      map_element 'element1', to: :root_attr2
      map_element 'element2', to: :root_attr3
      map_element 'element_bool', to: :root_bool
      map_element 'element_complex', to: :root_attr_complex
      map_element 'element_using', using: {
        from: :root_attr_using_from_xml,
        to: :root_attr_using_to_xml,
      }
      map_element 'element_namespaced',
        to: :element_namespaced,
        namespace: 'http://ns1.com',
        prefix: 'ns1'
    end

    def root_attr_using_from_hash(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_hash(model, doc)
      doc['root_attr_using'] = model.root_attr_using
    end

    def root_attr_using_from_json(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_json(model, doc)
      doc['root_attr_using'] = model.root_attr_using
    end

    def root_attr_using_from_yaml(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_yaml(model, doc)
      doc['root_attr_using'] = model.root_attr_using
    end

    def root_attr_using_from_toml(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_toml(model, doc)
      doc['root_attr_using'] = model.root_attr_using
    end

    def root_attr_attribute_using_from_xml(model, value)
      model.root_attr_attribute_using = value
    end

    def root_attr_attribute_using_to_xml(model, element, doc)
      doc.add_attribute(element, 'attribute_using', model.root_attr_attribute_using)
    end

    def root_attr_using_from_xml(model, node)
      model.root_attr_using = node.text
    end

    def root_attr_using_to_xml(model, parent, doc)
      element = doc.create_element('element_using')
      doc.add_text(element, model.root_attr_using)
      doc.add_element(parent, element)
    end
  end

  class CdataChild < Shale::Mapper
    attribute :element1, Shale::Type::String

    xml do
      map_content to: :element1, cdata: true
    end
  end

  class CdataParent < Shale::Mapper
    attribute :element1, Shale::Type::String
    attribute :element2, Shale::Type::String, collection: true
    attribute :cdata_child, CdataChild

    xml do
      root 'cdata_parent'

      map_element 'element1', to: :element1, cdata: true
      map_element 'element2', to: :element2, cdata: true
      map_element 'cdata_child', to: :cdata_child
    end
  end

  class ContentUsing < Shale::Mapper
    attribute :content, Shale::Type::String

    xml do
      root 'content_using'

      map_content using: { from: :content_from_xml, to: :content_to_xml }
    end

    def content_from_xml(model, element)
      model.content = element.text.gsub(',', '|')
    end

    def content_to_xml(model, element, doc)
      doc.add_text(element, model.content.gsub('|', ','))
    end
  end

  class RenderNil < Shale::Mapper
    attribute :attr_true, Shale::Type::String
    attribute :attr_false, Shale::Type::String
    attribute :xml_attr_true, Shale::Type::String
    attribute :xml_attr_false, Shale::Type::String

    attribute :ns_attr_true, Shale::Type::String
    attribute :ns_attr_false, Shale::Type::String
    attribute :ns_xml_attr_true, Shale::Type::String
    attribute :ns_xml_attr_false, Shale::Type::String

    hsh do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    json do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    yaml do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    toml do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    xml do
      root 'render_nil'

      map_attribute 'xml_attr_true', to: :xml_attr_true, render_nil: true
      map_attribute 'xml_attr_false', to: :xml_attr_false, render_nil: false
      map_element 'attr_true', to: :attr_true, render_nil: true
      map_element 'attr_false', to: :attr_false, render_nil: false

      map_attribute 'ns_xml_attr_true',
        to: :ns_xml_attr_true, namespace: 'http://ns1', prefix: 'ns1', render_nil: true
      map_attribute 'ns_xml_attr_false',
        to: :ns_xml_attr_false, namespace: 'http://ns2', prefix: 'ns2', render_nil: false
      map_element 'ns_attr_true',
        to: :ns_attr_true, namespace: 'http://ns3', prefix: 'ns3', render_nil: true
      map_element 'ns_attr_false',
        to: :ns_attr_false, namespace: 'http://ns4', prefix: 'ns4', render_nil: false
    end
  end

  class ComplexTypeModel
    attr_accessor :complex_attr1

    def initialize(complex_attr1: nil)
      @complex_attr1 = complex_attr1
    end
  end

  class ElementNamespacedModel
    attr_accessor :attr1, :ns1_attr1, :ns2_attr1,
      :not_namespaced, :ns1_one, :ns2_one

    def initialize(
      attr1: nil, ns1_attr1: nil, ns2_attr1: nil,
      not_namespaced: nil, ns1_one: nil, ns2_one: nil
    )
      @attr1 = attr1
      @ns1_attr1 = ns1_attr1
      @ns2_attr1 = ns2_attr1
      @not_namespaced = not_namespaced
      @ns1_one = ns1_one
      @ns2_one = ns2_one
    end
  end

  class RootTypeModel
    attr_accessor :root_attr1, :root_attr2, :root_attr3,
      :root_bool, :root_collection, :root_attr_complex,
      :root_attr_using, :root_attr_attribute_using, :element_namespaced

    def initialize(
      root_attr1: nil, root_attr2: nil, root_attr3: nil,
      root_bool: nil, root_collection: nil, root_attr_complex: nil,
      root_attr_using: nil, root_attr_attribute_using: nil, element_namespaced: nil
    )
      @root_attr1 = root_attr1
      @root_attr2 = root_attr2
      @root_attr3 = root_attr3
      @root_bool = root_bool
      @root_collection = root_collection
      @root_attr_complex = root_attr_complex
      @root_attr_using = root_attr_using
      @root_attr_attribute_using = root_attr_attribute_using
      @element_namespaced = element_namespaced
    end
  end

  module OnlyExceptOptions
    class Street < Shale::Mapper
      attribute :name, Shale::Type::String
      attribute :house_no, Shale::Type::String
      attribute :flat_no, Shale::Type::String

      xml do
        root 'Street'

        map_content to: :name
        map_attribute 'house_no', to: :house_no
        map_element 'FlatNo', to: :flat_no
      end
    end

    class Address < Shale::Mapper
      attribute :city, Shale::Type::String
      attribute :zip, Shale::Type::String
      attribute :street, Street

      xml do
        root 'Address'

        map_content to: :city
        map_attribute 'zip', to: :zip
        map_element 'Street', to: :street
      end
    end

    class Car < Shale::Mapper
      attribute :brand, Shale::Type::String
      attribute :model, Shale::Type::String
      attribute :engine, Shale::Type::String

      xml do
        root 'Car'

        map_content to: :brand
        map_attribute 'engine', to: :engine
        map_element 'Model', to: :model
      end
    end

    class Person < Shale::Mapper
      attribute :first_name, Shale::Type::String
      attribute :last_name, Shale::Type::String
      attribute :age, Shale::Type::Integer
      attribute :address, Address
      attribute :car, Car, collection: true

      xml do
        root 'Person'

        map_content to: :first_name
        map_attribute 'age', to: :age
        map_element 'LastName', to: :last_name
        map_element 'Address', to: :address
        map_element 'Car', to: :car
      end
    end
  end

  module ContextOption
    class Address < Shale::Mapper
      attribute :city, Shale::Type::String
      attribute :street, Shale::Type::String
      attribute :number, Shale::Type::String

      hsh do
        map 'city', using: { from: :city_from, to: :city_to }
      end

      json do
        map 'city', using: { from: :city_from, to: :city_to }
      end

      yaml do
        map 'city', using: { from: :city_from, to: :city_to }
      end

      toml do
        map 'city', using: { from: :city_from, to: :city_to }
      end

      xml do
        root 'address'

        map_content using: { from: :city_from_xml, to: :city_to_xml }
        map_element 'street', using: { from: :street_from_xml, to: :street_to_xml }
        map_attribute 'number', using: { from: :number_from_xml, to: :number_to_xml }
      end

      def city_from(model, value, context)
        model.city = "#{value}:#{context}"
      end

      def city_to(model, doc, context)
        doc['city'] = "#{model.city}:#{context}"
      end

      def city_from_xml(model, node, context)
        model.city = "#{node.text}:#{context}"
      end

      def city_to_xml(model, parent, doc, context)
        doc.add_text(parent, "#{model.city}:#{context}")
      end

      def street_from_xml(model, node, context)
        model.street = "#{node.text}:#{context}"
      end

      def street_to_xml(model, parent, doc, context)
        el = doc.create_element('street')
        doc.add_text(el, "#{model.street}:#{context}")
        doc.add_element(parent, el)
      end

      def number_from_xml(model, value, context)
        model.number = "#{value}:#{context}"
      end

      def number_to_xml(model, parent, doc, context)
        doc.add_attribute(parent, 'number', "#{model.number}:#{context}")
      end
    end

    class Person < Shale::Mapper
      attribute :first_name, Shale::Type::String
      attribute :last_name, Shale::Type::String
      attribute :age, Shale::Type::String
      attribute :address, Address

      hsh do
        map 'first_name', using: { from: :first_name_from, to: :first_name_to }
        map 'address', to: :address
      end

      json do
        map 'first_name', using: { from: :first_name_from, to: :first_name_to }
        map 'address', to: :address
      end

      yaml do
        map 'first_name', using: { from: :first_name_from, to: :first_name_to }
        map 'address', to: :address
      end

      toml do
        map 'first_name', using: { from: :first_name_from, to: :first_name_to }
        map 'address', to: :address
      end

      xml do
        root 'person'

        map_content using: { from: :first_name_from_xml, to: :first_name_to_xml }
        map_element 'last_name', using: { from: :last_name_from_xml, to: :last_name_to_xml }
        map_attribute 'age', using: { from: :age_from_xml, to: :age_to_xml }
        map_element 'address', to: :address
      end

      def first_name_from(model, value, context)
        model.first_name = "#{value}:#{context}"
      end

      def first_name_to(model, doc, context)
        doc['first_name'] = "#{model.first_name}:#{context}"
      end

      def first_name_from_xml(model, node, context)
        model.first_name = "#{node.text}:#{context}"
      end

      def first_name_to_xml(model, parent, doc, context)
        doc.add_text(parent, "#{model.first_name}:#{context}")
      end

      def last_name_from_xml(model, node, context)
        model.last_name = "#{node.text}:#{context}"
      end

      def last_name_to_xml(model, parent, doc, context)
        el = doc.create_element('last_name')
        doc.add_text(el, "#{model.last_name}:#{context}")
        doc.add_element(parent, el)
      end

      def age_from_xml(model, value, context)
        model.age = "#{value}:#{context}"
      end

      def age_to_xml(model, parent, doc, context)
        doc.add_attribute(parent, 'age', "#{model.age}:#{context}")
      end
    end
  end

  module Types
    class Child < Shale::Mapper
      attribute :type_boolean, Shale::Type::Boolean
      attribute :type_date, Shale::Type::Date
      attribute :type_float, Shale::Type::Float
      attribute :type_integer, Shale::Type::Integer
      attribute :type_string, Shale::Type::String
      attribute :type_time, Shale::Type::Time
      attribute :type_value, Shale::Type::Value
    end

    class Root < Shale::Mapper
      attribute :type_boolean, Shale::Type::Boolean
      attribute :type_date, Shale::Type::Date
      attribute :type_float, Shale::Type::Float
      attribute :type_integer, Shale::Type::Integer
      attribute :type_string, Shale::Type::String
      attribute :type_time, Shale::Type::Time
      attribute :type_value, Shale::Type::Value
      attribute :child, Child
    end
  end

  class UsingGroupWithoutContext < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String
    attribute :three, Shale::Type::String

    hsh do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    json do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    yaml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    toml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    xml do
      root 'el'
      group from: :attrs_from_xml, to: :attrs_to_xml do
        map_element 'one'
        map_attribute 'two'
        map_content
      end
    end

    def attrs_from_dict(model, value)
      model.one = value['one']
      model.two = value['two']
    end

    def attrs_to_dict(model, doc)
      doc['one'] = model.one
      doc['two'] = model.two
    end

    def attrs_from_xml(model, value)
      model.one = value[:elements]['one'].text
      model.two = value[:attributes]['two']
      model.three = value[:content].text
    end

    def attrs_to_xml(model, element, doc)
      doc.add_attribute(element, 'two', model.two)
      doc.add_text(element, model.three)

      one = doc.create_element('one')
      doc.add_text(one, model.one)
      doc.add_element(element, one)
    end
  end

  class UsingGroupWithContext < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String
    attribute :three, Shale::Type::String

    hsh do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    json do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    yaml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    toml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    xml do
      root 'el'
      group from: :attrs_from_xml, to: :attrs_to_xml do
        map_element 'one'
        map_attribute 'two'
        map_content
      end
    end

    def attrs_from_dict(model, value, context)
      model.one = value['one'] + context
      model.two = value['two'] + context
    end

    def attrs_to_dict(model, doc, context)
      doc['one'] = model.one + context
      doc['two'] = model.two + context
    end

    def attrs_from_xml(model, value, context)
      model.one = value[:elements]['one'].text + context
      model.two = value[:attributes]['two'] + context
      model.three = value[:content].text + context
    end

    def attrs_to_xml(model, element, doc, context)
      doc.add_attribute(element, 'two', model.two + context)
      doc.add_text(element, model.three + context)

      one = doc.create_element('one')
      doc.add_text(one, model.one + context)
      doc.add_element(element, one)
    end
  end
end

RSpec.describe Shale::Type::Complex do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
    Shale.yaml_adapter = YAML
    Shale.toml_adapter = Tomlib
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  context 'with no custom models' do
    before(:each) do
      ShaleComplexTesting::RootType.model(ShaleComplexTesting::RootType)
      ShaleComplexTesting::ComplexType.model(ShaleComplexTesting::ComplexType)
      ShaleComplexTesting::ElementNamespaced.model(ShaleComplexTesting::ElementNamespaced)
    end

    context 'with hash mapping' do
      let(:hash) do
        {
          'root_attr1' => 'foo',
          'root_attr2' => %w[one two three],
          'root_bool' => false,
          'root_attr_complex' => { 'complex_attr1' => 'bar' },
          'root_attr_using' => 'using_foo',
        }
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = ShaleComplexTesting::RootType.from_hash(hash)

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end

        it 'maps collection to array' do
          instance = ShaleComplexTesting::RootType.from_hash([hash, hash])

          expect(instance.class).to eq(Array)
          expect(instance.length).to eq(2)

          2.times do |i|
            expect(instance[i].class).to eq(ShaleComplexTesting::RootType)
            expect(instance[i].root_attr1).to eq('foo')
            expect(instance[i].root_attr2).to eq(%w[one two three])
            expect(instance[i].root_attr3).to eq(nil)
            expect(instance[i].root_bool).to eq(false)
            expect(instance[i].root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
            expect(instance[i].root_attr_complex.complex_attr1).to eq('bar')
            expect(instance[i].root_attr_using).to eq('using_foo')
          end
        end
      end

      describe '.to_hash' do
        it 'converts objects to hash' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'using_foo'
          )

          expect(instance.to_hash).to eq(hash)
        end

        it 'converts array to collection' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'using_foo'
          )

          array = ShaleComplexTesting::RootType.to_hash([instance, instance])
          expect(array).to eq([hash, hash])
        end
      end
    end

    context 'with json mapping' do
      let(:json) do
        <<~JSON
          {
            "root_attr1": "foo",
            "root_attr2": [
              "one",
              "two",
              "three"
            ],
            "root_bool": false,
            "root_attr_complex": {
              "complex_attr1": "bar"
            },
            "root_attr_using": "using_foo"
          }
        JSON
      end

      describe '.from_json' do
        it 'maps json to object' do
          instance = ShaleComplexTesting::RootType.from_json(json)

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end

        it 'maps collection to array' do
          instance = ShaleComplexTesting::RootType.from_json("[#{json},#{json}]")

          expect(instance.class).to eq(Array)
          expect(instance.length).to eq(2)

          2.times do |i|
            expect(instance[i].class).to eq(ShaleComplexTesting::RootType)
            expect(instance[i].root_attr1).to eq('foo')
            expect(instance[i].root_attr2).to eq(%w[one two three])
            expect(instance[i].root_attr3).to eq(nil)
            expect(instance[i].root_bool).to eq(false)
            expect(instance[i].root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
            expect(instance[i].root_attr_complex.complex_attr1).to eq('bar')
            expect(instance[i].root_attr_using).to eq('using_foo')
          end
        end
      end

      describe '.to_json' do
        context 'without params' do
          it 'converts objects to json' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            expect(instance.to_json).to eq(json.gsub(/\s+/, ''))
          end

          it 'converts array to json' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            array = ShaleComplexTesting::RootType.to_json([instance, instance])
            expect(array).to eq("[#{json},#{json}]".gsub(/\s+/, ''))
          end
        end

        context 'with pretty: true param' do
          it 'converts objects to json and formats it' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            expect(instance.to_json(pretty: true)).to eq(json.sub(/\n\z/, ''))
          end

          it 'converts array to json and formats it' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            array = ShaleComplexTesting::RootType.to_json([instance, instance], pretty: true)

            json_indent = json.sub(/\n\z/, '').gsub(/\n/, "\n  ")
            expect(array).to eq("[\n  #{json_indent},\n  #{json_indent}\n]")
          end
        end
      end
    end

    context 'with yaml mapping' do
      let(:yaml) do
        <<~YAML
          ---
          root_attr1: foo
          root_attr2:
          - one
          - two
          - three
          root_bool: false
          root_attr_complex:
            complex_attr1: bar
          root_attr_using: using_foo
        YAML
      end

      let(:yaml_collection) do
        <<~YAML
          ---
          - root_attr1: foo
            root_attr2:
            - one
            - two
            - three
            root_bool: false
            root_attr_complex:
              complex_attr1: bar
            root_attr_using: using_foo
          - root_attr1: foo
            root_attr2:
            - one
            - two
            - three
            root_bool: false
            root_attr_complex:
              complex_attr1: bar
            root_attr_using: using_foo
        YAML
      end

      describe '.from_yaml' do
        it 'maps yaml to object' do
          instance = ShaleComplexTesting::RootType.from_yaml(yaml)

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end

        it 'maps yaml to array' do
          instance = ShaleComplexTesting::RootType.from_yaml(yaml_collection)

          expect(instance.class).to eq(Array)
          expect(instance.length).to eq(2)
          2.times do |i|
            expect(instance[i].class).to eq(ShaleComplexTesting::RootType)
            expect(instance[i].root_attr1).to eq('foo')
            expect(instance[i].root_attr2).to eq(%w[one two three])
            expect(instance[i].root_attr3).to eq(nil)
            expect(instance[i].root_bool).to eq(false)
            expect(instance[i].root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
            expect(instance[i].root_attr_complex.complex_attr1).to eq('bar')
            expect(instance[i].root_attr_using).to eq('using_foo')
          end
        end
      end

      describe '.to_yaml' do
        it 'converts objects to yaml' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'using_foo'
          )

          expect(instance.to_yaml.gsub(/ +$/, '')).to eq(yaml)
        end

        it 'converts array to yaml' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'using_foo'
          )

          array = ShaleComplexTesting::RootType.to_yaml([instance, instance])
          expect(array).to eq(yaml_collection)
        end
      end
    end

    context 'with toml mapping' do
      let(:from_toml) do
        <<~TOML
          root_attr1 = "foo"
          root_attr2 = ["one", "two", "three"]
          root_bool = false
          root_attr_using = "using_foo"
          [root_attr_complex]
          complex_attr1 = "bar"
        TOML
      end

      let(:to_toml) do
        <<~TOML
          root_attr1 = "foo"
          root_attr2 = [ "one", "two", "three" ]
          root_bool = false
          root_attr_using = "using_foo"

          [root_attr_complex]
          complex_attr1 = "bar"
        TOML
      end

      describe '.from_toml' do
        it 'maps toml to object' do
          instance = ShaleComplexTesting::RootType.from_toml(from_toml)

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end
      end

      describe '.to_toml' do
        it 'converts objects to toml' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'using_foo'
          )

          expect(instance.to_toml).to eq(to_toml)
        end

        it 'raises an error when converting array' do
          msg = "argument is a 'Array' but should be a 'ShaleComplexTesting::RootType'"

          expect do
            ShaleComplexTesting::RootType.to_toml([])
          end.to raise_error(Shale::IncorrectModelError, msg)
        end
      end
    end

    context 'with xml mapping' do
      let(:xml) do
        <<~XML
          <root_type attr1="foo"
            attribute_using="foo"
            collection="[&quot;collection&quot;]"
            xmlns:ns1="http://ns1.com"
            xmlns:ns2="http://ns2.com">
            <element1>one</element1>
            <element1>two</element1>
            <element1>three</element1>
            <element_bool>false</element_bool>
            <element_complex>bar</element_complex>
            <element_using>foo_element_using</element_using>
            <ns1:element_namespaced attr1="attr1" ns1:attr1="ns1 attr1" ns2:attr1="ns2 attr1">
              <not_namespaced>not namespaced</not_namespaced>
              <ns1:one>ns1 element one</ns1:one>
              <ns2:one>ns2 element one</ns2:one>
            </ns1:element_namespaced>
          </root_type>
        XML
      end

      describe '.from_xml' do
        context 'when XML adapter is not set' do
          it 'raises an error' do
            Shale.xml_adapter = nil

            expect do
              ShaleComplexTesting::RootType.from_xml(xml)
            end.to raise_error(Shale::AdapterError, /XML Adapter is not set/)
          end
        end

        context 'when XML adapter is set' do
          it 'maps xml to object' do
            instance = ShaleComplexTesting::RootType.from_xml(xml)

            expect(instance.class).to eq(ShaleComplexTesting::RootType)
            expect(instance.root_attr1).to eq('foo')
            expect(instance.root_attr2).to eq(%w[one two three])
            expect(instance.root_attr3).to eq(nil)
            expect(instance.root_bool).to eq(false)
            expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
            expect(instance.root_attr_complex.complex_attr1).to eq('bar')
            expect(instance.root_attr_using).to eq('foo_element_using')
            expect(instance.root_attr_attribute_using).to eq('foo')
            expect(instance.element_namespaced.class).to eq(ShaleComplexTesting::ElementNamespaced)
            expect(instance.element_namespaced.attr1).to eq('attr1')
            expect(instance.element_namespaced.ns1_attr1).to eq('ns1 attr1')
            expect(instance.element_namespaced.ns2_attr1).to eq('ns2 attr1')
            expect(instance.element_namespaced.not_namespaced).to eq('not namespaced')
            expect(instance.element_namespaced.ns1_one).to eq('ns1 element one')
            expect(instance.element_namespaced.ns2_one).to eq('ns2 element one')
          end
        end

        context 'with CDATA elements' do
          let(:xml) do
            <<~XML
              <cdata_type>
                <element1>foo</element1>
                <element2>one</element2>
                <element2>two</element2>
                <element2>three</element2>
                <cdata_child>child</cdata_child>
              </cdata_type>
            XML
          end

          it 'maps xml to object' do
            instance = ShaleComplexTesting::CdataParent.from_xml(xml)

            expect(instance.element1).to eq('foo')
            expect(instance.element2).to eq(%w[one two three])
            expect(instance.cdata_child.element1).to eq('child')
          end
        end

        context 'with content using methods' do
          let(:xml) do
            <<~XML
              <content_using>foo,bar,baz</content_using>
            XML
          end

          it 'maps xml to object' do
            instance = ShaleComplexTesting::ContentUsing.from_xml(xml)

            expect(instance.content).to eq('foo|bar|baz')
          end
        end
      end

      describe '.to_xml' do
        context 'when XML adapter is not set' do
          it 'raises an error' do
            Shale.xml_adapter = nil

            expect do
              ShaleComplexTesting::RootType.new.to_xml
            end.to raise_error(Shale::AdapterError, /XML Adapter is not set/)
          end
        end

        context 'without params' do
          it 'converts objects to xml' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_collection: ['collection'],
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo',
              element_namespaced: ShaleComplexTesting::ElementNamespaced.new(
                attr1: 'attr1',
                ns1_attr1: 'ns1 attr1',
                ns2_attr1: 'ns2 attr1',
                not_namespaced: 'not namespaced',
                ns1_one: 'ns1 element one',
                ns2_one: 'ns2 element one'
              )
            )

            expect(instance.to_xml).to eq(xml.gsub(/>\s+/, '>').gsub(/"\s+/, '" '))
          end

          it 'converts blank attributes to xml' do
            instance = ShaleComplexTesting::RootType.new(root_attr1: '')
            expected = '<root_type attr1="" attribute_using="" collection="[]">' \
                       '<element_using/></root_type>'
            expect(instance.to_xml).to eq(expected)
          end
        end

        context 'with pretty: true param' do
          it 'converts objects to xml and formats it' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_bool: false,
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo'
            )

            xml = <<~XML.sub(/\n\z/, '')
              <root_type attr1="foo" collection="[]" attribute_using="foo">
                <element_bool>false</element_bool>
                <element_using>foo_element_using</element_using>
              </root_type>
            XML

            expect(instance.to_xml(pretty: true)).to eq(xml)
          end
        end

        context 'with declaration: true param' do
          it 'converts objects to xml with declaration' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_bool: false,
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo'
            )

            xml = <<~XML.gsub(/>\s+/, '>').gsub(/'\s+/, "' ")
              <?xml version="1.0"?>
              <root_type attr1="foo" attribute_using="foo" collection="[]">
                <element_bool>false</element_bool>
                <element_using>foo_element_using</element_using>
              </root_type>
            XML

            expect(instance.to_xml(declaration: true)).to eq(xml)
          end
        end

        context 'with declaration: true and encoding: true param' do
          it 'converts objects to xml with declaration' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_bool: false,
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo'
            )

            xml = <<~XML.gsub(/>\s+/, '>').gsub(/'\s+/, "' ")
              <?xml version="1.0" encoding="UTF-8"?>
              <root_type attr1="foo" attribute_using="foo" collection="[]">
                <element_bool>false</element_bool>
                <element_using>foo_element_using</element_using>
              </root_type>
            XML

            expect(instance.to_xml(declaration: true, encoding: true)).to eq(xml)
          end
        end

        context 'with declaration: "1.1" and encoding: "ASCII" param' do
          it 'converts objects to xml with declaration' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_bool: false,
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo'
            )

            xml = <<~XML.gsub(/>\s+/, '>').gsub(/'\s+/, "' ")
              <?xml version="1.1" encoding="ASCII"?>
              <root_type attr1="foo" attribute_using="foo" collection="[]">
                <element_bool>false</element_bool>
                <element_using>foo_element_using</element_using>
              </root_type>
            XML

            expect(instance.to_xml(declaration: '1.1', encoding: 'ASCII')).to eq(xml)
          end
        end

        context 'with pretty: true and declaration: true param' do
          it 'converts objects to xml with declaration and formats it' do
            instance = ShaleComplexTesting::RootType.new(
              root_attr1: 'foo',
              root_bool: false,
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo'
            )

            xml = <<~XML.sub(/\n\z/, '')
              <?xml version="1.0"?>
              <root_type attr1="foo" collection="[]" attribute_using="foo">
                <element_bool>false</element_bool>
                <element_using>foo_element_using</element_using>
              </root_type>
            XML

            expect(instance.to_xml(pretty: true, declaration: true)).to eq(xml)
          end
        end

        context 'with CDATA elements' do
          it 'converts objects to xml' do
            instance = ShaleComplexTesting::CdataParent.new(
              element1: 'foo',
              element2: %w[one two three],
              cdata_child: ShaleComplexTesting::CdataChild.new(element1: 'child')
            )

            xml = <<~XML.sub(/\n\z/, '')
              <cdata_parent>
                <element1><![CDATA[foo]]></element1>
                <element2><![CDATA[one]]></element2>
                <element2><![CDATA[two]]></element2>
                <element2><![CDATA[three]]></element2>
                <cdata_child><![CDATA[child]]></cdata_child>
              </cdata_parent>
            XML

            expect(instance.to_xml(pretty: true)).to eq(xml)
          end
        end

        context 'with content using methods' do
          it 'converts objects to xml' do
            instance = ShaleComplexTesting::ContentUsing.new(content: 'foo|bar|baz')

            xml = <<~XML.sub(/\n\z/, '')
              <content_using>foo,bar,baz</content_using>
            XML

            expect(instance.to_xml(pretty: true)).to eq(xml)
          end
        end
      end
    end
  end

  context 'with custom models' do
    before(:each) do
      ShaleComplexTesting::RootType.model(ShaleComplexTesting::RootTypeModel)
      ShaleComplexTesting::ComplexType.model(ShaleComplexTesting::ComplexTypeModel)
      ShaleComplexTesting::ElementNamespaced.model(ShaleComplexTesting::ElementNamespacedModel)
    end

    context 'with hash mapping' do
      let(:hash) do
        {
          'root_attr1' => 'foo',
          'root_attr2' => %w[one two three],
          'root_bool' => false,
          'root_attr_complex' => { 'complex_attr1' => 'bar' },
          'root_attr_using' => 'using_foo',
        }
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = ShaleComplexTesting::RootType.from_hash(hash)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end

        it 'maps collection to array' do
          instance = ShaleComplexTesting::RootType.from_hash([hash, hash])

          expect(instance.class).to eq(Array)
          expect(instance.length).to eq(2)
          2.times do |i|
            expect(instance[i].class).to eq(ShaleComplexTesting::RootTypeModel)
            expect(instance[i].root_attr1).to eq('foo')
            expect(instance[i].root_attr2).to eq(%w[one two three])
            expect(instance[i].root_attr3).to eq(nil)
            expect(instance[i].root_bool).to eq(false)
            expect(instance[i].root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
            expect(instance[i].root_attr_complex.complex_attr1).to eq('bar')
            expect(instance[i].root_attr_using).to eq('using_foo')
          end
        end
      end

      describe '.to_hash' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_hash('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to hash' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            expect(ShaleComplexTesting::RootType.to_hash(instance)).to eq(hash)
          end

          it 'converts objects to array' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            result = ShaleComplexTesting::RootType.to_hash([instance, instance])
            expect(result).to eq([hash, hash])
          end
        end
      end
    end

    context 'with json mapping' do
      let(:json) do
        <<~JSON
          {
            "root_attr1": "foo",
            "root_attr2": [
              "one",
              "two",
              "three"
            ],
            "root_bool": false,
            "root_attr_complex": {
              "complex_attr1": "bar"
            },
            "root_attr_using": "using_foo"
          }
        JSON
      end

      let(:json_collection) do
        <<~JSON
          [
            {
              "root_attr1": "foo",
              "root_attr2": [
                "one",
                "two",
                "three"
              ],
              "root_bool": false,
              "root_attr_complex": {
                "complex_attr1": "bar"
              },
              "root_attr_using": "using_foo"
            },
            {
              "root_attr1": "foo",
              "root_attr2": [
                "one",
                "two",
                "three"
              ],
              "root_bool": false,
              "root_attr_complex": {
                "complex_attr1": "bar"
              },
              "root_attr_using": "using_foo"
            }
          ]
        JSON
      end

      describe '.from_json' do
        it 'maps json to object' do
          instance = ShaleComplexTesting::RootType.from_json(json)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end

        it 'maps json to array' do
          instance = ShaleComplexTesting::RootType.from_json(json_collection)

          expect(instance.class).to eq(Array)
          expect(instance.length).to eq(2)
          2.times do |i|
            expect(instance[i].class).to eq(ShaleComplexTesting::RootTypeModel)
            expect(instance[i].root_attr1).to eq('foo')
            expect(instance[i].root_attr2).to eq(%w[one two three])
            expect(instance[i].root_attr3).to eq(nil)
            expect(instance[i].root_bool).to eq(false)
            expect(instance[i].root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
            expect(instance[i].root_attr_complex.complex_attr1).to eq('bar')
            expect(instance[i].root_attr_using).to eq('using_foo')
          end
        end
      end

      describe '.to_json' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_json('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to json' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            result = ShaleComplexTesting::RootType.to_json(instance)
            expect(result).to eq(json.gsub(/\s+/, ''))
          end

          it 'converts array to json' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            result = ShaleComplexTesting::RootType.to_json([instance, instance])
            expect(result).to eq(json_collection.gsub(/\s+/, ''))
          end
        end
      end
    end

    context 'with yaml mapping' do
      let(:yaml) do
        <<~YAML
          ---
          root_attr1: foo
          root_attr2:
          - one
          - two
          - three
          root_bool: false
          root_attr_complex:
            complex_attr1: bar
          root_attr_using: using_foo
        YAML
      end
      let(:yaml_collection) do
        <<~YAML
          ---
          - root_attr1: foo
            root_attr2:
            - one
            - two
            - three
            root_bool: false
            root_attr_complex:
              complex_attr1: bar
            root_attr_using: using_foo
          - root_attr1: foo
            root_attr2:
            - one
            - two
            - three
            root_bool: false
            root_attr_complex:
              complex_attr1: bar
            root_attr_using: using_foo
        YAML
      end

      describe '.from_yaml' do
        it 'maps yaml to object' do
          instance = ShaleComplexTesting::RootType.from_yaml(yaml)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end

        it 'maps yaml to array' do
          instance = ShaleComplexTesting::RootType.from_yaml(yaml_collection)

          expect(instance.class).to eq(Array)
          expect(instance.length).to eq(2)
          2.times do |i|
            expect(instance[i].class).to eq(ShaleComplexTesting::RootTypeModel)
            expect(instance[i].root_attr1).to eq('foo')
            expect(instance[i].root_attr2).to eq(%w[one two three])
            expect(instance[i].root_attr3).to eq(nil)
            expect(instance[i].root_bool).to eq(false)
            expect(instance[i].root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
            expect(instance[i].root_attr_complex.complex_attr1).to eq('bar')
            expect(instance[i].root_attr_using).to eq('using_foo')
          end
        end
      end

      describe '.to_yaml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_yaml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to yaml' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            result = ShaleComplexTesting::RootType.to_yaml(instance)
            expect(result.gsub(/ +$/, '')).to eq(yaml)
          end

          it 'converts array to yaml' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            result = ShaleComplexTesting::RootType.to_yaml([instance, instance])
            expect(result.gsub(/ +$/, '')).to eq(yaml_collection)
          end
        end
      end
    end

    context 'with toml mapping' do
      let(:from_toml) do
        <<~TOML
          root_attr1 = "foo"
          root_attr2 = ["one", "two", "three"]
          root_bool = false
          root_attr_using = "using_foo"
          [root_attr_complex]
          complex_attr1 = "bar"
        TOML
      end

      let(:to_toml) do
        <<~TOML
          root_attr1 = "foo"
          root_attr2 = [ "one", "two", "three" ]
          root_bool = false
          root_attr_using = "using_foo"

          [root_attr_complex]
          complex_attr1 = "bar"
        TOML
      end

      describe '.from_toml' do
        it 'maps toml to object' do
          instance = ShaleComplexTesting::RootType.from_toml(from_toml)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end
      end

      describe '.to_toml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_toml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with array' do
          it 'raises an exception' do
            msg = /argument is a 'Array' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_toml([])
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to toml' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            expect(ShaleComplexTesting::RootType.to_toml(instance)).to eq(to_toml)
          end
        end
      end
    end

    context 'with xml mapping' do
      let(:xml) do
        <<~XML
          <root_type_model attr1="foo"
            attribute_using="foo"
            collection="[&quot;collection&quot;]"
            xmlns:ns1="http://ns1.com"
            xmlns:ns2="http://ns2.com">
            <element1>one</element1>
            <element1>two</element1>
            <element1>three</element1>
            <element_bool>false</element_bool>
            <element_complex>bar</element_complex>
            <element_using>foo_element_using</element_using>
            <ns1:element_namespaced attr1="attr1" ns1:attr1="ns1 attr1" ns2:attr1="ns2 attr1">
              <not_namespaced>not namespaced</not_namespaced>
              <ns1:one>ns1 element one</ns1:one>
              <ns2:one>ns2 element one</ns2:one>
            </ns1:element_namespaced>
          </root_type_model>
        XML
      end

      describe '.from_xml' do
        it 'maps xml to object' do
          instance = ShaleComplexTesting::RootType.from_xml(xml)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('foo_element_using')
          expect(instance.root_attr_attribute_using).to eq('foo')
          expect(instance.element_namespaced.class).to(
            eq(ShaleComplexTesting::ElementNamespacedModel)
          )
          expect(instance.element_namespaced.attr1).to eq('attr1')
          expect(instance.element_namespaced.ns1_attr1).to eq('ns1 attr1')
          expect(instance.element_namespaced.ns2_attr1).to eq('ns2 attr1')
          expect(instance.element_namespaced.not_namespaced).to eq('not namespaced')
          expect(instance.element_namespaced.ns1_one).to eq('ns1 element one')
          expect(instance.element_namespaced.ns2_one).to eq('ns2 element one')
        end
      end

      describe '.to_xml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_xml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to xml' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_collection: ['collection'],
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo',
              element_namespaced: ShaleComplexTesting::ElementNamespacedModel.new(
                attr1: 'attr1',
                ns1_attr1: 'ns1 attr1',
                ns2_attr1: 'ns2 attr1',
                not_namespaced: 'not namespaced',
                ns1_one: 'ns1 element one',
                ns2_one: 'ns2 element one'
              )
            )

            result = ShaleComplexTesting::RootType.to_xml(instance)
            expect(result).to eq(xml.gsub(/>\s+/, '>').gsub(/"\s+/, '" '))
          end
        end
      end
    end
  end

  context 'with render_nil' do
    describe '.to_hash' do
      let(:expected_nil) do
        {
          'attr_true' => nil,
        }
      end

      let(:expected_set) do
        {
          'attr_true' => 'foo',
          'attr_false' => 'bar',
        }
      end

      it 'converts objects to hash' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar'
        )

        expect(instance1.to_hash).to eq(expected_nil)
        expect(instance2.to_hash).to eq(expected_set)
      end
    end

    describe '.to_json' do
      let(:expected_nil) do
        <<~JSON.sub(/\n\z/, '')
          {
            "attr_true": null
          }
        JSON
      end

      let(:expected_set) do
        <<~JSON.sub(/\n\z/, '')
          {
            "attr_true": "foo",
            "attr_false": "bar"
          }
        JSON
      end

      it 'converts objects to JSON' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar'
        )

        expect(instance1.to_json(pretty: true)).to eq(expected_nil)
        expect(instance2.to_json(pretty: true)).to eq(expected_set)
      end
    end

    describe '.to_yaml' do
      let(:expected_nil) do
        <<~YAML
          ---
          attr_true:
        YAML
      end

      let(:expected_set) do
        <<~YAML
          ---
          attr_true: foo
          attr_false: bar
        YAML
      end

      it 'converts objects to YAML' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar'
        )

        expect(instance1.to_yaml.gsub(/ +$/, '')).to eq(expected_nil)
        expect(instance2.to_yaml).to eq(expected_set)
      end
    end

    describe '.to_toml' do
      let(:expected_nil) do
        <<~TOML
          attr_true = ""
        TOML
      end

      let(:expected_set) do
        <<~TOML
          attr_true = "foo"
          attr_false = "bar"
        TOML
      end

      it 'converts objects to TOML' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar'
        )

        expect(instance1.to_toml).to eq(expected_nil)
        expect(instance2.to_toml).to eq(expected_set)
      end
    end

    describe '.to_xml' do
      let(:expected_nil) do
        <<~XML.gsub(/>\s+/, '>').gsub(/"\s+/, '" ')
          <render_nil xmlns:ns1="http://ns1"
            xmlns:ns3="http://ns3"
            ns1:ns_xml_attr_true=""
            xml_attr_true="">
            <attr_true/>
            <ns3:ns_attr_true/>
          </render_nil>
        XML
      end

      let(:expected_set) do
        <<~XML.gsub(/>\s+/, '>').gsub(/"\s+/, '" ')
          <render_nil xmlns:ns1="http://ns1"
            xmlns:ns2="http://ns2"
            xmlns:ns3="http://ns3"
            xmlns:ns4="http://ns4"
            ns2:ns_xml_attr_false="mot"
            ns1:ns_xml_attr_true="ked"
            xml_attr_false="nab"
            xml_attr_true="baz">
            <attr_true>foo</attr_true>
            <attr_false>bar</attr_false>
            <ns3:ns_attr_true>zed</ns3:ns_attr_true>
            <ns4:ns_attr_false>led</ns4:ns_attr_false>
          </render_nil>
        XML
      end

      it 'converts objects to XML' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil,
          xml_attr_true: nil,
          xml_attr_false: nil,

          ns_attr_true: nil,
          ns_attr_false: nil,
          ns_xml_attr_true: nil,
          ns_xml_attr_false: nil
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar',
          xml_attr_true: 'baz',
          xml_attr_false: 'nab',

          ns_attr_true: 'zed',
          ns_attr_false: 'led',
          ns_xml_attr_true: 'ked',
          ns_xml_attr_false: 'mot'
        )

        expect(instance1.to_xml).to eq(expected_nil)
        expect(instance2.to_xml).to eq(expected_set)
      end
    end
  end

  context 'with only/except options' do
    subject(:mapper) { ShaleComplexTesting::OnlyExceptOptions::Person }

    context 'with hash mapping' do
      let(:hash) do
        {
          'first_name' => 'John',
          'last_name' => 'Doe',
          'age' => 44,
          'address' => {
            'city' => 'London',
            'zip' => '1N ASD123',
            'street' => {
              'name' => 'Oxford Street', 'house_no' => '1', 'flat_no' => '2'
            },
          },
          'car' => [
            { 'brand' => 'Honda', 'model' => 'Accord', 'engine' => '1.4' },
            { 'brand' => 'Toyota', 'model' => 'Corolla', 'engine' => '2.0' },
          ],
        }
      end

      let(:hash_collection) do
        [
          {
            'first_name' => 'John',
            'last_name' => 'Doe',
            'age' => 44,
            'address' => {
              'city' => 'London',
              'zip' => '1N ASD123',
              'street' => {
                'name' => 'Oxford Street', 'house_no' => '1', 'flat_no' => '2'
              },
            },
            'car' => [
              { 'brand' => 'Honda', 'model' => 'Accord', 'engine' => '1.4' },
              { 'brand' => 'Toyota', 'model' => 'Corolla', 'engine' => '2.0' },
            ],
          },
          {
            'first_name' => 'John',
            'last_name' => 'Doe',
            'age' => 44,
            'address' => {
              'city' => 'London',
              'zip' => '1N ASD123',
              'street' => {
                'name' => 'Oxford Street', 'house_no' => '1', 'flat_no' => '2'
              },
            },
            'car' => [
              { 'brand' => 'Honda', 'model' => 'Accord', 'engine' => '1.4' },
              { 'brand' => 'Toyota', 'model' => 'Corolla', 'engine' => '2.0' },
            ],
          },
        ]
      end

      describe '.from_hash' do
        it 'maps hash to partial object' do
          instance = mapper.from_hash(
            hash,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_hash(
            hash,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end

        it 'maps collection to partial object' do
          instance = mapper.from_hash(
            hash_collection,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq('John')
            expect(instance[i].last_name).to eq(nil)
            expect(instance[i].age).to eq(nil)
            expect(instance[i].address.city).to eq(nil)
            expect(instance[i].address.zip).to eq('1N ASD123')
            expect(instance[i].address.street.name).to eq(nil)
            expect(instance[i].address.street.house_no).to eq(nil)
            expect(instance[i].address.street.flat_no).to eq('2')
            expect(instance[i].car[0].brand).to eq(nil)
            expect(instance[i].car[0].model).to eq('Accord')
            expect(instance[i].car[0].engine).to eq(nil)
            expect(instance[i].car[1].brand).to eq(nil)
            expect(instance[i].car[1].model).to eq('Corolla')
            expect(instance[i].car[1].engine).to eq(nil)
          end

          instance = mapper.from_hash(
            hash_collection,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq(nil)
            expect(instance[i].last_name).to eq('Doe')
            expect(instance[i].age).to eq(44)
            expect(instance[i].address.city).to eq('London')
            expect(instance[i].address.zip).to eq(nil)
            expect(instance[i].address.street.name).to eq('Oxford Street')
            expect(instance[i].address.street.house_no).to eq('1')
            expect(instance[i].address.street.flat_no).to eq(nil)
            expect(instance[i].car[0].brand).to eq('Honda')
            expect(instance[i].car[0].model).to eq(nil)
            expect(instance[i].car[0].engine).to eq('1.4')
            expect(instance[i].car[1].brand).to eq('Toyota')
            expect(instance[i].car[1].model).to eq(nil)
            expect(instance[i].car[1].engine).to eq('2.0')
          end
        end
      end

      describe '.to_hash' do
        it 'converts objects to partial hash' do
          instance = mapper.from_hash(hash)

          result = instance.to_hash(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq({
            'first_name' => 'John',
            'address' => {
              'zip' => '1N ASD123',
              'street' => { 'flat_no' => '2' },
            },
            'car' => [
              { 'model' => 'Accord' },
              { 'model' => 'Corolla' },
            ],
          })

          result = instance.to_hash(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq({
            'last_name' => 'Doe',
            'age' => 44,
            'address' => {
              'city' => 'London',
              'street' => { 'name' => 'Oxford Street', 'house_no' => '1' },
            },
            'car' => [
              { 'brand' => 'Honda', 'engine' => '1.4' },
              { 'brand' => 'Toyota', 'engine' => '2.0' },
            ],
          })
        end

        it 'converts array to partial hash' do
          instance = mapper.from_hash(hash_collection)

          result = mapper.to_hash(
            instance,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(
            [
              {
                'first_name' => 'John',
                'address' => {
                  'zip' => '1N ASD123',
                  'street' => { 'flat_no' => '2' },
                },
                'car' => [
                  { 'model' => 'Accord' },
                  { 'model' => 'Corolla' },
                ],
              },
              {
                'first_name' => 'John',
                'address' => {
                  'zip' => '1N ASD123',
                  'street' => { 'flat_no' => '2' },
                },
                'car' => [
                  { 'model' => 'Accord' },
                  { 'model' => 'Corolla' },
                ],
              },
            ]
          )

          result = mapper.to_hash(
            instance,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(
            [
              {
                'last_name' => 'Doe',
                'age' => 44,
                'address' => {
                  'city' => 'London',
                  'street' => { 'name' => 'Oxford Street', 'house_no' => '1' },
                },
                'car' => [
                  { 'brand' => 'Honda', 'engine' => '1.4' },
                  { 'brand' => 'Toyota', 'engine' => '2.0' },
                ],
              },
              {
                'last_name' => 'Doe',
                'age' => 44,
                'address' => {
                  'city' => 'London',
                  'street' => { 'name' => 'Oxford Street', 'house_no' => '1' },
                },
                'car' => [
                  { 'brand' => 'Honda', 'engine' => '1.4' },
                  { 'brand' => 'Toyota', 'engine' => '2.0' },
                ],
              },
            ]
          )
        end
      end
    end

    context 'with JSON mapping' do
      let(:json) do
        <<~DOC
          {
            "first_name": "John",
            "last_name": "Doe",
            "age": 44,
            "hobby": [
              "Singing",
              "Dancing"
            ],
            "address": {
              "city": "London",
              "zip": "1N ASD123",
              "street": {
                "name": "Oxford Street",
                "house_no": "1",
                "flat_no": "2"
              }
            },
            "car": [
              {
                "brand": "Honda",
                "model": "Accord",
                "engine": "1.4"
              },
              {
                "brand": "Toyota",
                "model": "Corolla",
                "engine": "2.0"
              }
            ]
          }
        DOC
      end

      let(:json_collection) do
        <<~DOC
          [
            {
              "first_name": "John",
              "last_name": "Doe",
              "age": 44,
              "hobby": [
                "Singing",
                "Dancing"
              ],
              "address": {
                "city": "London",
                "zip": "1N ASD123",
                "street": {
                  "name": "Oxford Street",
                  "house_no": "1",
                  "flat_no": "2"
                }
              },
              "car": [
                {
                  "brand": "Honda",
                  "model": "Accord",
                  "engine": "1.4"
                },
                {
                  "brand": "Toyota",
                  "model": "Corolla",
                  "engine": "2.0"
                }
              ]
            },
            {
              "first_name": "John",
              "last_name": "Doe",
              "age": 44,
              "hobby": [
                "Singing",
                "Dancing"
              ],
              "address": {
                "city": "London",
                "zip": "1N ASD123",
                "street": {
                  "name": "Oxford Street",
                  "house_no": "1",
                  "flat_no": "2"
                }
              },
              "car": [
                {
                  "brand": "Honda",
                  "model": "Accord",
                  "engine": "1.4"
                },
                {
                  "brand": "Toyota",
                  "model": "Corolla",
                  "engine": "2.0"
                }
              ]
            }
          ]
        DOC
      end

      describe '.from_json' do
        it 'maps JSON to partial object' do
          instance = mapper.from_json(
            json,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_json(
            json,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end

        it 'maps JSON collection to partial object' do
          instance = mapper.from_json(
            json_collection,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq('John')
            expect(instance[i].last_name).to eq(nil)
            expect(instance[i].age).to eq(nil)
            expect(instance[i].address.city).to eq(nil)
            expect(instance[i].address.zip).to eq('1N ASD123')
            expect(instance[i].address.street.name).to eq(nil)
            expect(instance[i].address.street.house_no).to eq(nil)
            expect(instance[i].address.street.flat_no).to eq('2')
            expect(instance[i].car[0].brand).to eq(nil)
            expect(instance[i].car[0].model).to eq('Accord')
            expect(instance[i].car[0].engine).to eq(nil)
            expect(instance[i].car[1].brand).to eq(nil)
            expect(instance[i].car[1].model).to eq('Corolla')
            expect(instance[i].car[1].engine).to eq(nil)
          end

          instance = mapper.from_json(
            json_collection,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq(nil)
            expect(instance[i].last_name).to eq('Doe')
            expect(instance[i].age).to eq(44)
            expect(instance[i].address.city).to eq('London')
            expect(instance[i].address.zip).to eq(nil)
            expect(instance[i].address.street.name).to eq('Oxford Street')
            expect(instance[i].address.street.house_no).to eq('1')
            expect(instance[i].address.street.flat_no).to eq(nil)
            expect(instance[i].car[0].brand).to eq('Honda')
            expect(instance[i].car[0].model).to eq(nil)
            expect(instance[i].car[0].engine).to eq('1.4')
            expect(instance[i].car[1].brand).to eq('Toyota')
            expect(instance[i].car[1].model).to eq(nil)
            expect(instance[i].car[1].engine).to eq('2.0')
          end
        end
      end

      describe '.to_json' do
        it 'converts objects to partial JSON' do
          instance = mapper.from_json(json)

          result = instance.to_json(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            {
              "first_name": "John",
              "address": {
                "zip": "1N ASD123",
                "street": {
                  "flat_no": "2"
                }
              },
              "car": [
                {
                  "model": "Accord"
                },
                {
                  "model": "Corolla"
                }
              ]
            }
          DOC

          result = instance.to_json(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            {
              "last_name": "Doe",
              "age": 44,
              "address": {
                "city": "London",
                "street": {
                  "name": "Oxford Street",
                  "house_no": "1"
                }
              },
              "car": [
                {
                  "brand": "Honda",
                  "engine": "1.4"
                },
                {
                  "brand": "Toyota",
                  "engine": "2.0"
                }
              ]
            }
          DOC
        end

        it 'converts array to partial JSON' do
          instance = mapper.from_json(json_collection)

          result = mapper.to_json(
            instance,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            [
              {
                "first_name": "John",
                "address": {
                  "zip": "1N ASD123",
                  "street": {
                    "flat_no": "2"
                  }
                },
                "car": [
                  {
                    "model": "Accord"
                  },
                  {
                    "model": "Corolla"
                  }
                ]
              },
              {
                "first_name": "John",
                "address": {
                  "zip": "1N ASD123",
                  "street": {
                    "flat_no": "2"
                  }
                },
                "car": [
                  {
                    "model": "Accord"
                  },
                  {
                    "model": "Corolla"
                  }
                ]
              }
            ]
          DOC

          result = mapper.to_json(
            instance,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            [
              {
                "last_name": "Doe",
                "age": 44,
                "address": {
                  "city": "London",
                  "street": {
                    "name": "Oxford Street",
                    "house_no": "1"
                  }
                },
                "car": [
                  {
                    "brand": "Honda",
                    "engine": "1.4"
                  },
                  {
                    "brand": "Toyota",
                    "engine": "2.0"
                  }
                ]
              },
              {
                "last_name": "Doe",
                "age": 44,
                "address": {
                  "city": "London",
                  "street": {
                    "name": "Oxford Street",
                    "house_no": "1"
                  }
                },
                "car": [
                  {
                    "brand": "Honda",
                    "engine": "1.4"
                  },
                  {
                    "brand": "Toyota",
                    "engine": "2.0"
                  }
                ]
              }
            ]
          DOC
        end
      end
    end

    context 'with YAML mapping' do
      let(:yaml) do
        <<~DOC
          ---
          first_name: John
          last_name: Doe
          age: 44
          hobby:
          - Singing
          - Dancing
          address:
            city: London
            zip: 1N ASD123
            street:
              name: Oxford Street
              house_no: '1'
              flat_no: '2'
          car:
          - brand: Honda
            model: Accord
            engine: '1.4'
          - brand: Toyota
            model: Corolla
            engine: '2.0'
        DOC
      end

      let(:yaml_collection) do
        <<~DOC
          ---
          - first_name: John
            last_name: Doe
            age: 44
            hobby:
            - Singing
            - Dancing
            address:
              city: London
              zip: 1N ASD123
              street:
                name: Oxford Street
                house_no: '1'
                flat_no: '2'
            car:
            - brand: Honda
              model: Accord
              engine: '1.4'
            - brand: Toyota
              model: Corolla
              engine: '2.0'
          - first_name: John
            last_name: Doe
            age: 44
            hobby:
            - Singing
            - Dancing
            address:
              city: London
              zip: 1N ASD123
              street:
                name: Oxford Street
                house_no: '1'
                flat_no: '2'
            car:
            - brand: Honda
              model: Accord
              engine: '1.4'
            - brand: Toyota
              model: Corolla
              engine: '2.0'
        DOC
      end

      describe '.from_yaml' do
        it 'maps YAML to partial object' do
          instance = mapper.from_yaml(
            yaml,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_yaml(
            yaml,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end

        it 'maps YAML collection to partial object' do
          instance = mapper.from_yaml(
            yaml_collection,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq('John')
            expect(instance[i].last_name).to eq(nil)
            expect(instance[i].age).to eq(nil)
            expect(instance[i].address.city).to eq(nil)
            expect(instance[i].address.zip).to eq('1N ASD123')
            expect(instance[i].address.street.name).to eq(nil)
            expect(instance[i].address.street.house_no).to eq(nil)
            expect(instance[i].address.street.flat_no).to eq('2')
            expect(instance[i].car[0].brand).to eq(nil)
            expect(instance[i].car[0].model).to eq('Accord')
            expect(instance[i].car[0].engine).to eq(nil)
            expect(instance[i].car[1].brand).to eq(nil)
            expect(instance[i].car[1].model).to eq('Corolla')
            expect(instance[i].car[1].engine).to eq(nil)
          end

          instance = mapper.from_yaml(
            yaml_collection,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq(nil)
            expect(instance[i].last_name).to eq('Doe')
            expect(instance[i].age).to eq(44)
            expect(instance[i].address.city).to eq('London')
            expect(instance[i].address.zip).to eq(nil)
            expect(instance[i].address.street.name).to eq('Oxford Street')
            expect(instance[i].address.street.house_no).to eq('1')
            expect(instance[i].address.street.flat_no).to eq(nil)
            expect(instance[i].car[0].brand).to eq('Honda')
            expect(instance[i].car[0].model).to eq(nil)
            expect(instance[i].car[0].engine).to eq('1.4')
            expect(instance[i].car[1].brand).to eq('Toyota')
            expect(instance[i].car[1].model).to eq(nil)
            expect(instance[i].car[1].engine).to eq('2.0')
          end
        end
      end

      describe '.to_yaml' do
        it 'converts objects to partial YAML' do
          instance = mapper.from_yaml(yaml)

          result = instance.to_yaml(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            first_name: John
            address:
              zip: 1N ASD123
              street:
                flat_no: '2'
            car:
            - model: Accord
            - model: Corolla
          DOC

          result = instance.to_yaml(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            last_name: Doe
            age: 44
            address:
              city: London
              street:
                name: Oxford Street
                house_no: '1'
            car:
            - brand: Honda
              engine: '1.4'
            - brand: Toyota
              engine: '2.0'
          DOC
        end

        it 'converts array to partial YAML' do
          instance = mapper.from_yaml(yaml_collection)

          result = mapper.to_yaml(
            instance,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            - first_name: John
              address:
                zip: 1N ASD123
                street:
                  flat_no: '2'
              car:
              - model: Accord
              - model: Corolla
            - first_name: John
              address:
                zip: 1N ASD123
                street:
                  flat_no: '2'
              car:
              - model: Accord
              - model: Corolla
          DOC

          result = mapper.to_yaml(
            instance,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            - last_name: Doe
              age: 44
              address:
                city: London
                street:
                  name: Oxford Street
                  house_no: '1'
              car:
              - brand: Honda
                engine: '1.4'
              - brand: Toyota
                engine: '2.0'
            - last_name: Doe
              age: 44
              address:
                city: London
                street:
                  name: Oxford Street
                  house_no: '1'
              car:
              - brand: Honda
                engine: '1.4'
              - brand: Toyota
                engine: '2.0'
          DOC
        end
      end
    end

    context 'with TOML mapping' do
      let(:toml) do
        <<~DOC
          first_name = "John"
          last_name = "Doe"
          age = 44
          hobby = [ "Singing", "Dancing" ]

          [address]
          city = "London"
          zip = "1N ASD123"

            [address.street]
            name = "Oxford Street"
            house_no = "1"
            flat_no = "2"

          [[car]]
          brand = "Honda"
          model = "Accord"
          engine = "1.4"

          [[car]]
          brand = "Toyota"
          model = "Corolla"
          engine = "2.0"
        DOC
      end

      describe '.from_toml' do
        it 'maps TOML to partial object' do
          instance = mapper.from_toml(
            toml,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_toml(
            toml,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end
      end

      describe '.to_toml' do
        it 'converts objects to partial TOML' do
          instance = mapper.from_toml(toml)

          result = instance.to_toml(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            first_name = "John"

            [address]
            zip = "1N ASD123"

              [address.street]
              flat_no = "2"

            [[car]]
            model = "Accord"

            [[car]]
            model = "Corolla"
          DOC

          result = instance.to_toml(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            last_name = "Doe"
            age = 44

            [address]
            city = "London"

              [address.street]
              name = "Oxford Street"
              house_no = "1"

            [[car]]
            brand = "Honda"
            engine = "1.4"

            [[car]]
            brand = "Toyota"
            engine = "2.0"
          DOC
        end
      end
    end

    context 'with XML mapping' do
      let(:xml) do
        <<~DOC
          <Person age="44">
            John
            <LastName>Doe</LastName>
            <Hobby>Singing</Hobby>
            <Hobby>Dancing</Hobby>
            <Address zip="1N ASD123">
              London
              <Street house_no="1">
                Oxford Street
                <FlatNo>2</FlatNo>
              </Street>
            </Address>
            <Car engine="1.4">
              Honda
              <Model>Accord</Model>
            </Car>
            <Car engine="2.0">
              Toyota
              <Model>Corolla</Model>
            </Car>
          </Person>
        DOC
      end

      describe '.from_xml' do
        it 'maps XML to partial object' do
          instance = mapper.from_xml(
            xml,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq("\n  John\n  ")
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_xml(
            xml,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq("\n    London\n    ")
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq("\n      Oxford Street\n      ")
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq("\n    Honda\n    ")
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq("\n    Toyota\n    ")
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end
      end

      describe '.to_xml' do
        it 'converts objects to partial XML' do
          instance = mapper.from_xml(xml)
          instance.first_name = instance.first_name.strip
          instance.address.city = instance.address.city.strip
          instance.address.street.name = instance.address.street.name.strip
          instance.car[0].brand = instance.car[0].brand.strip
          instance.car[1].brand = instance.car[1].brand.strip

          result = instance.to_xml(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            <Person>
              John
              <Address zip="1N ASD123">
                <Street>
                  <FlatNo>2</FlatNo>
                </Street>
              </Address>
              <Car>
                <Model>Accord</Model>
              </Car>
              <Car>
                <Model>Corolla</Model>
              </Car>
            </Person>
          DOC

          result = instance.to_xml(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            <Person age="44">
              <LastName>Doe</LastName>
              <Address>
                London
                <Street house_no="1">Oxford Street</Street>
              </Address>
              <Car engine="1.4">Honda</Car>
              <Car engine="2.0">Toyota</Car>
            </Person>
          DOC
        end
      end
    end
  end

  context 'with context option' do
    subject(:mapper) { ShaleComplexTesting::ContextOption::Person }
    subject(:address_class) { ShaleComplexTesting::ContextOption::Address }

    context 'with hash mapping' do
      let(:hash) do
        {
          'first_name' => 'John',
          'address' => {
            'city' => 'London',
          },
        }
      end

      let(:hash_collection) do
        [
          {
            'first_name' => 'John',
            'address' => {
              'city' => 'London',
            },
          },
          {
            'first_name' => 'John',
            'address' => {
              'city' => 'London',
            },
          },
        ]
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = mapper.from_hash(hash, context: 'foo')

          expect(instance.first_name).to eq('John:foo')
          expect(instance.address.city).to eq('London:foo')
        end

        it 'maps array to object' do
          instance = mapper.from_hash(hash_collection, context: 'foo')

          2.times do |i|
            expect(instance[i].first_name).to eq('John:foo')
            expect(instance[i].address.city).to eq('London:foo')
          end
        end
      end

      describe '.to_hash' do
        it 'converts objects to hash' do
          instance = mapper.new(first_name: 'John', address: address_class.new(city: 'London'))

          result = instance.to_hash(context: 'bar')
          expect(result).to eq({
            'first_name' => 'John:bar',
            'address' => {
              'city' => 'London:bar',
            },
          })
        end

        it 'converts objects to array' do
          instance = mapper.new(first_name: 'John', address: address_class.new(city: 'London'))

          result = mapper.to_hash([instance, instance], context: 'bar')
          expect(result).to eq(
            [
              {
                'first_name' => 'John:bar',
                'address' => {
                  'city' => 'London:bar',
                },
              },
              {
                'first_name' => 'John:bar',
                'address' => {
                  'city' => 'London:bar',
                },
              },
            ]
          )
        end
      end
    end

    context 'with JSON mapping' do
      let(:json) do
        <<~DOC
          {
            "first_name": "John",
            "address": {
              "city": "London"
            }
          }
        DOC
      end

      let(:json_collection) do
        <<~DOC
          [
            {
              "first_name": "John",
              "address": {
                "city": "London"
              }
            },
            {
              "first_name": "John",
              "address": {
                "city": "London"
              }
            }
          ]
        DOC
      end

      describe '.from_json' do
        it 'maps JSON to object' do
          instance = mapper.from_json(json, context: 'foo')

          expect(instance.first_name).to eq('John:foo')
          expect(instance.address.city).to eq('London:foo')
        end

        it 'maps JSON to array' do
          instance = mapper.from_json(json_collection, context: 'foo')

          2.times do |i|
            expect(instance[i].first_name).to eq('John:foo')
            expect(instance[i].address.city).to eq('London:foo')
          end
        end
      end

      describe '.to_json' do
        it 'converts objects to JSON' do
          instance = mapper.new(first_name: 'John', address: address_class.new(city: 'London'))

          result = instance.to_json(context: 'bar', pretty: true)
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            {
              "first_name": "John:bar",
              "address": {
                "city": "London:bar"
              }
            }
          DOC
        end

        it 'converts array to JSON' do
          instance = mapper.new(first_name: 'John', address: address_class.new(city: 'London'))

          result = mapper.to_json([instance, instance], context: 'bar', pretty: true)
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            [
              {
                "first_name": "John:bar",
                "address": {
                  "city": "London:bar"
                }
              },
              {
                "first_name": "John:bar",
                "address": {
                  "city": "London:bar"
                }
              }
            ]
          DOC
        end
      end
    end

    context 'with YAML mapping' do
      let(:yaml) do
        <<~DOC
          ---
          first_name: John
          address:
            city: London
        DOC
      end

      let(:yaml_collection) do
        <<~DOC
          ---
          - first_name: John
            address:
              city: London
          - first_name: John
            address:
              city: London
        DOC
      end

      describe '.from_yaml' do
        it 'maps YAML to object' do
          instance = mapper.from_yaml(yaml, context: 'foo')

          expect(instance.first_name).to eq('John:foo')
          expect(instance.address.city).to eq('London:foo')
        end

        it 'maps YAML to array' do
          instance = mapper.from_yaml(yaml_collection, context: 'foo')

          2.times do |i|
            expect(instance[i].first_name).to eq('John:foo')
            expect(instance[i].address.city).to eq('London:foo')
          end
        end
      end

      describe '.to_yaml' do
        it 'converts objects to YAML' do
          instance = mapper.new(first_name: 'John', address: address_class.new(city: 'London'))

          result = instance.to_yaml(context: 'bar')
          expect(result).to eq(<<~DOC)
            ---
            first_name: John:bar
            address:
              city: London:bar
          DOC
        end

        it 'converts array to YAML' do
          instance = mapper.new(first_name: 'John', address: address_class.new(city: 'London'))

          result = mapper.to_yaml([instance, instance], context: 'bar')
          expect(result).to eq(<<~DOC)
            ---
            - first_name: John:bar
              address:
                city: London:bar
            - first_name: John:bar
              address:
                city: London:bar
          DOC
        end
      end
    end

    context 'with TOML mapping' do
      let(:toml) do
        <<~DOC
          first_name = "John"

          [address]
          city = "London"
        DOC
      end

      describe '.from_toml' do
        it 'maps TOML to object' do
          instance = mapper.from_toml(toml, context: 'foo')

          expect(instance.first_name).to eq('John:foo')
          expect(instance.address.city).to eq('London:foo')
        end
      end

      describe '.to_toml' do
        it 'converts objects to TOML' do
          instance = mapper.new(first_name: 'John', address: address_class.new(city: 'London'))

          result = instance.to_toml(context: 'bar')
          expect(result).to eq(<<~DOC)
            first_name = "John:bar"

            [address]
            city = "London:bar"
          DOC
        end
      end
    end

    context 'with XML mapping' do
      let(:xml) do
        <<~DOC
          <person age="44">
            John
            <last_name>Doe</last_name>
            <address number="12">
              London
              <street>Oxford Street</street>
            </address>
          </person>
        DOC
      end

      describe '.from_xml' do
        it 'maps XML to object' do
          instance = mapper.from_xml(xml, context: 'foo')

          expect(instance.first_name).to eq("\n  John\n  :foo")
          expect(instance.last_name).to eq('Doe:foo')
          expect(instance.age).to eq('44:foo')
          expect(instance.address.city).to eq("\n    London\n    :foo")
          expect(instance.address.street).to eq('Oxford Street:foo')
          expect(instance.address.number).to eq('12:foo')
        end
      end

      describe '.to_xml' do
        it 'converts objects to XML' do
          instance = mapper.new(
            first_name: 'John',
            last_name: 'Doe',
            age: '44',
            address: address_class.new(city: 'London', street: 'Oxford Street', number: '12')
          )

          result = instance.to_xml(context: 'bar', pretty: true)

          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            <person age="44:bar">
              John:bar
              <last_name>Doe:bar</last_name>
              <address number="12:bar">
                London:bar
                <street>Oxford Street:bar</street>
              </address>
            </person>
          DOC
        end
      end
    end
  end

  context 'with different types' do
    subject(:mapper) { ShaleComplexTesting::Types::Root }

    context 'with hash mapping' do
      let(:hash) do
        {
          'type_boolean' => true,
          'type_date' => Date.new(2022, 1, 1),
          'type_float' => 1.1,
          'type_integer' => 1,
          'type_string' => 'foo',
          'type_time' => Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
          'type_value' => 'foo',
          'child' => {
            'type_boolean' => true,
            'type_date' => Date.new(2022, 1, 1),
            'type_float' => 1.1,
            'type_integer' => 1,
            'type_string' => 'foo',
            'type_time' => Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            'type_value' => 'foo',
          },
        }
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = mapper.from_hash(hash)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')
        end
      end

      describe '.to_hash' do
        it 'converts objects to hash' do
          instance = mapper.from_hash(hash)

          result = instance.to_hash
          expect(result).to eq(hash)
        end
      end
    end

    context 'with JSON mapping' do
      let(:json) do
        <<~DOC
          {
            "type_boolean": true,
            "type_date": "2022-01-01",
            "type_float": 1.1,
            "type_integer": 1,
            "type_string": "foo",
            "type_time": "2021-01-01T10:10:10+01:00",
            "type_value": "foo",
            "child": {
              "type_boolean": true,
              "type_date": "2022-01-01",
              "type_float": 1.1,
              "type_integer": 1,
              "type_string": "foo",
              "type_time": "2021-01-01T10:10:10+01:00",
              "type_value": "foo"
            }
          }
        DOC
      end

      describe '.from_json' do
        it 'maps JSON to object' do
          instance = mapper.from_json(json)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')
        end
      end

      describe '.to_json' do
        it 'converts objects to JSON' do
          instance = mapper.from_json(json)

          result = instance.to_json(pretty: true)
          expect(result).to eq(json.gsub(/\n\z/, ''))
        end
      end
    end

    context 'with YAML mapping' do
      let(:yaml) do
        <<~DOC
          ---
          type_boolean: true
          type_date: '2022-01-01'
          type_float: 1.1
          type_integer: 1
          type_string: foo
          type_time: '2021-01-01T10:10:10+01:00'
          type_value: foo
          child:
            type_boolean: true
            type_date: '2022-01-01'
            type_float: 1.1
            type_integer: 1
            type_string: foo
            type_time: '2021-01-01T10:10:10+01:00'
            type_value: foo
        DOC
      end

      describe '.from_yaml' do
        it 'maps YAML to object' do
          instance = mapper.from_yaml(yaml)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')
        end
      end

      describe '.to_yaml' do
        it 'converts objects to YAML' do
          instance = mapper.from_yaml(yaml)

          result = instance.to_yaml
          expect(result).to eq(yaml)
        end
      end
    end

    context 'with TOML mapping' do
      let(:toml) do
        <<~DOC
          type_boolean = true
          type_date = 2022-01-01
          type_float = 1.1
          type_integer = 1
          type_string = "foo"
          type_time = 2021-01-01T10:10:10.000+01:00
          type_value = "foo"

          [child]
          type_boolean = true
          type_date = 2022-01-01
          type_float = 1.1
          type_integer = 1
          type_string = "foo"
          type_time = 2021-01-01T10:10:10.000+01:00
          type_value = "foo"
        DOC
      end

      describe '.from_toml' do
        it 'maps TOML to object' do
          instance = mapper.from_toml(toml)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')
        end
      end

      describe '.to_toml' do
        it 'converts objects to TOML' do
          instance = mapper.from_toml(toml)

          result = instance.to_toml
          expect(result).to eq(toml)
        end
      end
    end

    context 'with XML mapping' do
      let(:xml) do
        <<~DOC
          <root>
            <type_boolean>true</type_boolean>
            <type_date>2022-01-01</type_date>
            <type_float>1.1</type_float>
            <type_integer>1</type_integer>
            <type_string>foo</type_string>
            <type_time>2021-01-01T10:10:10+01:00</type_time>
            <type_value>foo</type_value>
            <child>
              <type_boolean>true</type_boolean>
              <type_date>2022-01-01</type_date>
              <type_float>1.1</type_float>
              <type_integer>1</type_integer>
              <type_string>foo</type_string>
              <type_time>2021-01-01T10:10:10+01:00</type_time>
              <type_value>foo</type_value>
            </child>
          </root>
        DOC
      end

      describe '.from_xml' do
        it 'maps XML to object' do
          instance = mapper.from_xml(xml)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')
        end
      end

      describe '.to_xml' do
        it 'converts objects to XML' do
          instance = mapper.from_xml(xml)

          result = instance.to_xml(pretty: true)
          expect(result).to eq(xml.gsub(/\n\z/, ''))
        end
      end
    end
  end

  context 'with using' do
    context 'without context' do
      subject(:mapper) { ShaleComplexTesting::UsingGroupWithoutContext }

      context 'with hash mapping' do
        let(:hash) do
          {
            'one' => 'one',
            'two' => 'two',
          }
        end

        describe '.from_hash' do
          it 'maps hash to object' do
            instance = mapper.from_hash(hash)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end
        end

        describe '.to_hash' do
          it 'converts objects to hash' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_hash
            expect(result).to eq({
              'one' => 'one',
              'two' => 'two',
            })
          end
        end
      end

      context 'with JSON mapping' do
        let(:json) do
          <<~DOC
            {
              "one": "one",
              "two": "two"
            }
          DOC
        end

        describe '.from_json' do
          it 'maps JSON to object' do
            instance = mapper.from_json(json)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end
        end

        describe '.to_json' do
          it 'converts objects to JSON' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_json(pretty: true)
            expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
              {
                "one": "one",
                "two": "two"
              }
            DOC
          end
        end
      end

      context 'with YAML mapping' do
        let(:yaml) do
          <<~DOC
            ---
            one: one
            two: two
          DOC
        end

        describe '.from_yaml' do
          it 'maps YAML to object' do
            instance = mapper.from_yaml(yaml)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end
        end

        describe '.to_yaml' do
          it 'converts objects to YAML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_yaml
            expect(result).to eq(<<~DOC)
              ---
              one: one
              two: two
            DOC
          end
        end
      end

      context 'with TOML mapping' do
        let(:toml) do
          <<~DOC
            one = "one"
            two = "two"
          DOC
        end

        describe '.from_toml' do
          it 'maps TOML to object' do
            instance = mapper.from_toml(toml)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end
        end

        describe '.to_toml' do
          it 'converts objects to TOML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_toml
            expect(result).to eq(<<~DOC)
              one = "one"
              two = "two"
            DOC
          end
        end
      end

      context 'with XML mapping' do
        let(:xml) do
          <<~DOC
            <el two="two">three<one>one</one></el>
          DOC
        end

        describe '.from_xml' do
          it 'maps XML to object' do
            instance = mapper.from_xml(xml)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
            expect(instance.three).to eq('three')
          end
        end

        describe '.to_xml' do
          it 'converts objects to XML' do
            instance = mapper.new(one: 'one', two: 'two', three: 'three')

            result = instance.to_xml

            expect(result).to eq('<el two="two">three<one>one</one></el>')
          end
        end
      end
    end

    context 'with context' do
      subject(:mapper) { ShaleComplexTesting::UsingGroupWithContext }

      context 'with hash mapping' do
        let(:hash) do
          {
            'one' => 'one',
            'two' => 'two',
          }
        end

        describe '.from_hash' do
          it 'maps hash to object' do
            instance = mapper.from_hash(hash, context: 'foo')

            expect(instance.one).to eq('onefoo')
            expect(instance.two).to eq('twofoo')
          end
        end

        describe '.to_hash' do
          it 'converts objects to hash' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_hash(context: 'foo')
            expect(result).to eq({
              'one' => 'onefoo',
              'two' => 'twofoo',
            })
          end
        end
      end

      context 'with JSON mapping' do
        let(:json) do
          <<~DOC
            {
              "one": "one",
              "two": "two"
            }
          DOC
        end

        describe '.from_json' do
          it 'maps JSON to object' do
            instance = mapper.from_json(json, context: 'foo')

            expect(instance.one).to eq('onefoo')
            expect(instance.two).to eq('twofoo')
          end
        end

        describe '.to_json' do
          it 'converts objects to JSON' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_json(pretty: true, context: 'foo')
            expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
              {
                "one": "onefoo",
                "two": "twofoo"
              }
            DOC
          end
        end
      end

      context 'with YAML mapping' do
        let(:yaml) do
          <<~DOC
            ---
            one: one
            two: two
          DOC
        end

        describe '.from_yaml' do
          it 'maps YAML to object' do
            instance = mapper.from_yaml(yaml, context: 'foo')

            expect(instance.one).to eq('onefoo')
            expect(instance.two).to eq('twofoo')
          end
        end

        describe '.to_yaml' do
          it 'converts objects to YAML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_yaml(context: 'foo')
            expect(result).to eq(<<~DOC)
              ---
              one: onefoo
              two: twofoo
            DOC
          end
        end
      end

      context 'with TOML mapping' do
        let(:toml) do
          <<~DOC
            one = "one"
            two = "two"
          DOC
        end

        describe '.from_toml' do
          it 'maps TOML to object' do
            instance = mapper.from_toml(toml, context: 'foo')

            expect(instance.one).to eq('onefoo')
            expect(instance.two).to eq('twofoo')
          end
        end

        describe '.to_toml' do
          it 'converts objects to TOML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_toml(context: 'foo')
            expect(result).to eq(<<~DOC)
              one = "onefoo"
              two = "twofoo"
            DOC
          end
        end
      end

      context 'with XML mapping' do
        let(:xml) do
          <<~DOC
            <el two="two">three<one>one</one></el>
          DOC
        end

        describe '.from_xml' do
          it 'maps XML to object' do
            instance = mapper.from_xml(xml, context: 'foo')

            expect(instance.one).to eq('onefoo')
            expect(instance.two).to eq('twofoo')
            expect(instance.three).to eq('threefoo')
          end
        end

        describe '.to_xml' do
          it 'converts objects to XML' do
            instance = mapper.new(one: 'one', two: 'two', three: 'three')

            result = instance.to_xml(context: 'foo')

            expect(result).to eq('<el two="twofoo">threefoo<one>onefoo</one></el>')
          end
        end
      end
    end
  end
end
