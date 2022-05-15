# frozen_string_literal: true

require 'shale/schema/xml'
require 'shale/error'

module ShaleSchemaXMLTesting
  class BaseNameTesting < Shale::Mapper
    attribute :foo, Shale::Type::String
    attribute :bar, Shale::Type::String

    xml do
      map_element 'foo', to: :foo
      map_element 'bar', to: :bar, namespace: 'http://bar.com', prefix: 'bar'
    end
  end

  class BranchOne < Shale::Mapper
    attribute :one, Shale::Type::String

    xml do
      root 'branch_two'
      map_element 'One', to: :one
    end
  end

  class BranchTwo < Shale::Mapper
    attribute :two, Shale::Type::String

    xml do
      root 'branch_two'
      namespace 'http://foo.com', 'foo'
      map_element 'Two', to: :two
    end
  end

  class Root < Shale::Mapper
    attribute :boolean, Shale::Type::Boolean
    attribute :date, Shale::Type::Date
    attribute :float, Shale::Type::Float
    attribute :integer, Shale::Type::Integer
    attribute :string, Shale::Type::String
    attribute :time, Shale::Type::Time
    attribute :value, Shale::Type::Value

    attribute :boolean_default, Shale::Type::Boolean, default: -> { true }
    attribute :date_default, Shale::Type::Date, default: -> { Date.new(2021, 1, 1) }
    attribute :float_default, Shale::Type::Float, default: -> { 1.0 }
    attribute :integer_default, Shale::Type::Integer, default: -> { 1 }
    attribute :string_default, Shale::Type::String, default: -> { 'string' }
    attribute :time_default,
      Shale::Type::Time,
      default: -> { Time.new(2021, 1, 1, 10, 10, 10, '+01:00') }
    attribute :value_default, Shale::Type::Value, default: -> { 'value' }

    attribute :boolean_collection, Shale::Type::Boolean, collection: true
    attribute :date_collection, Shale::Type::Date, collection: true
    attribute :float_collection, Shale::Type::Float, collection: true
    attribute :integer_collection, Shale::Type::Integer, collection: true
    attribute :string_collection, Shale::Type::String, collection: true
    attribute :time_collection, Shale::Type::Time, collection: true
    attribute :value_collection, Shale::Type::Value, collection: true

    attribute :branch_one, BranchOne
    attribute :branch_two, BranchTwo
    attribute :circular_dependency, Root

    attribute :attribute_one, Shale::Type::String
    attribute :attribute_two, Shale::Type::String
    attribute :content, Shale::Type::String

    xml do
      root 'root'
      map_content to: :content
      map_attribute 'attribute_one', to: :attribute_one
      map_attribute 'attribute_two', to: :attribute_two, namespace: 'http://foo.com', prefix: 'foo'

      map_element 'boolean', to: :boolean
      map_element 'date', to: :date
      map_element 'float', to: :float
      map_element 'integer', to: :integer
      map_element 'string', to: :string
      map_element 'time', to: :time
      map_element 'value', to: :value

      map_element 'boolean_default', to: :boolean_default
      map_element 'date_default', to: :date_default
      map_element 'float_default', to: :float_default
      map_element 'integer_default', to: :integer_default
      map_element 'string_default', to: :string_default
      map_element 'time_default', to: :time_default
      map_element 'value_default', to: :value_default

      map_element 'boolean_collection', to: :boolean_collection
      map_element 'date_collection', to: :date_collection
      map_element 'float_collection', to: :float_collection
      map_element 'integer_collection', to: :integer_collection
      map_element 'string_collection', to: :string_collection
      map_element 'time_collection', to: :time_collection
      map_element 'value_collection', to: :value_collection

      map_element 'branch_one', to: :branch_one
      map_element 'branch_two', to: :branch_two, namespace: 'http://foo.com', prefix: 'foo'
      map_element 'circular_dependency', to: :circular_dependency
    end
  end

  class CircularDependencyB < Shale::Mapper
  end

  class CircularDependencyA < Shale::Mapper
    attribute :circular_dependency_b, CircularDependencyB
  end

  class CircularDependencyB
    attribute :circular_dependency_a, CircularDependencyA
  end
end

RSpec.describe Shale::Schema::XML do
  let(:expected_schema0) do
    <<~DATA.gsub(/\n\z/, '')
      <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:foo="http://foo.com">
        <xs:import namespace="http://foo.com" schemaLocation="schema1.xsd"/>
        <xs:element name="root" type="ShaleSchemaXMLTesting_Root"/>
        <xs:complexType name="ShaleSchemaXMLTesting_BranchOne">
          <xs:sequence>
            <xs:element name="One" type="xs:string" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
        <xs:complexType name="ShaleSchemaXMLTesting_Root" mixed="true">
          <xs:sequence>
            <xs:element name="boolean" type="xs:boolean" minOccurs="0"/>
            <xs:element name="date" type="xs:date" minOccurs="0"/>
            <xs:element name="float" type="xs:decimal" minOccurs="0"/>
            <xs:element name="integer" type="xs:integer" minOccurs="0"/>
            <xs:element name="string" type="xs:string" minOccurs="0"/>
            <xs:element name="time" type="xs:dateTime" minOccurs="0"/>
            <xs:element name="value" type="xs:string" minOccurs="0"/>
            <xs:element name="boolean_default" type="xs:boolean" minOccurs="0" default="true"/>
            <xs:element name="date_default" type="xs:date" minOccurs="0" default="2021-01-01"/>
            <xs:element name="float_default" type="xs:decimal" minOccurs="0" default="1.0"/>
            <xs:element name="integer_default" type="xs:integer" minOccurs="0" default="1"/>
            <xs:element name="string_default" type="xs:string" minOccurs="0" default="string"/>
            <xs:element name="time_default" type="xs:dateTime" minOccurs="0" default="2021-01-01T10:10:10+01:00"/>
            <xs:element name="value_default" type="xs:string" minOccurs="0" default="value"/>
            <xs:element name="boolean_collection" type="xs:boolean" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="date_collection" type="xs:date" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="float_collection" type="xs:decimal" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="integer_collection" type="xs:integer" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="string_collection" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="time_collection" type="xs:dateTime" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="value_collection" type="xs:string" minOccurs="0" maxOccurs="unbounded"/>
            <xs:element name="branch_one" type="ShaleSchemaXMLTesting_BranchOne" minOccurs="0"/>
            <xs:element ref="foo:branch_two" minOccurs="0"/>
            <xs:element name="circular_dependency" type="ShaleSchemaXMLTesting_Root" minOccurs="0"/>
          </xs:sequence>
          <xs:attribute name="attribute_one" type="xs:string"/>
          <xs:attribute ref="foo:attribute_two"/>
        </xs:complexType>
      </xs:schema>
    DATA
  end

  let(:expected_schema1) do
    <<~DATA.gsub(/\n\z/, '')
      <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" targetNamespace="http://foo.com" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:foo="http://foo.com">
        <xs:element name="branch_two" type="foo:ShaleSchemaXMLTesting_BranchTwo"/>
        <xs:attribute name="attribute_two" type="xs:string"/>
        <xs:complexType name="ShaleSchemaXMLTesting_BranchTwo">
          <xs:sequence>
            <xs:element name="Two" type="xs:string" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
      </xs:schema>
    DATA
  end

  let(:expected_schema_circular) do
    <<~DATA.gsub(/\n\z/, '')
      <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
        <xs:element name="circular_dependency_a" type="ShaleSchemaXMLTesting_CircularDependencyA"/>
        <xs:complexType name="ShaleSchemaXMLTesting_CircularDependencyA">
          <xs:sequence>
            <xs:element name="circular_dependency_b" type="ShaleSchemaXMLTesting_CircularDependencyB" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
        <xs:complexType name="ShaleSchemaXMLTesting_CircularDependencyB">
          <xs:sequence>
            <xs:element name="circular_dependency_a" type="ShaleSchemaXMLTesting_CircularDependencyA" minOccurs="0"/>
          </xs:sequence>
        </xs:complexType>
      </xs:schema>
    DATA
  end

  describe 'xml_types' do
    it 'registers new type' do
      described_class.register_xml_type('foo', 'bar')
      expect(described_class.get_xml_type('foo')).to eq('bar')
    end
  end

  describe '#as_schema' do
    context 'when incorrect argument' do
      it 'raises error' do
        expect do
          described_class.new.as_schemas(String)
        end.to raise_error(Shale::NotAShaleMapperError)
      end
    end

    context 'without base_name' do
      it 'generates schema with default name' do
        schemas = described_class.new.as_schemas(ShaleSchemaXMLTesting::BaseNameTesting)
        expect(schemas.map(&:name)).to eq(['schema0.xsd', 'schema1.xsd'])
      end
    end

    context 'without base_name' do
      it 'generates schema with name' do
        schemas = described_class.new.as_schemas(
          ShaleSchemaXMLTesting::BaseNameTesting,
          'foo'
        )
        expect(schemas.map(&:name)).to eq(['foo0.xsd', 'foo1.xsd'])
      end
    end

    context 'with correct arguments' do
      it 'generates XML schema' do
        schemas = described_class.new.as_schemas(ShaleSchemaXMLTesting::Root)

        schema0 = Shale.xml_adapter.dump(schemas[0].as_xml, :pretty)
        schema1 = Shale.xml_adapter.dump(schemas[1].as_xml, :pretty)

        expect(schema0).to eq(expected_schema0)
        expect(schema1).to eq(expected_schema1)
      end
    end

    context 'with classes depending on each other' do
      it 'generates XML schema' do
        schemas = described_class.new.as_schemas(
          ShaleSchemaXMLTesting::CircularDependencyA
        )

        schema0 = Shale.xml_adapter.dump(schemas[0].as_xml, :pretty)

        expect(schema0).to eq(expected_schema_circular)
      end
    end
  end

  describe '#to_schema' do
    context 'with pretty param' do
      it 'genrates XML document' do
        schemas = described_class.new.as_schemas(ShaleSchemaXMLTesting::BranchOne)
        schemas_xml = described_class.new.to_schemas(
          ShaleSchemaXMLTesting::BranchOne,
          pretty: true
        )

        expected = Shale.xml_adapter.dump(schemas[0].as_xml, :pretty)
        expect(schemas_xml.values[0]).to eq(expected)
      end
    end

    context 'with declaration param' do
      it 'genrates XML document' do
        schemas = described_class.new.as_schemas(ShaleSchemaXMLTesting::BranchOne)
        schemas_xml = described_class.new.to_schemas(
          ShaleSchemaXMLTesting::BranchOne,
          declaration: true
        )

        expected = Shale.xml_adapter.dump(schemas[0].as_xml, :declaration)
        expect(schemas_xml.values[0]).to eq(expected)
      end
    end

    context 'without pretty and declaration param' do
      it 'genrates XML document' do
        schemas = described_class.new.as_schemas(ShaleSchemaXMLTesting::BranchOne)
        schemas_xml = described_class.new.to_schemas(ShaleSchemaXMLTesting::BranchOne)

        expected = Shale.xml_adapter.dump(schemas[0].as_xml)
        expect(schemas_xml.values[0]).to eq(expected)
      end
    end
  end
end
