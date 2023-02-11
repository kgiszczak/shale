# frozen_string_literal: true

require 'shale/adapter/json'
require 'shale/adapter/rexml'
require 'shale/schema'

module ShaleSchemaTesting
  class Root < Shale::Mapper
    attribute :foo, Shale::Type::String
  end
end

RSpec.describe Shale::Schema do
  describe '.to_json' do
    let(:expected_json_schema) do
      <<~DATA.gsub(/\n\z/, '')
        {
          "$schema": "https://json-schema.org/draft/2020-12/schema",
          "$ref": "#/$defs/ShaleSchemaTesting_Root",
          "$defs": {
            "ShaleSchemaTesting_Root": {
              "type": "object",
              "properties": {
                "foo": {
                  "type": [
                    "string",
                    "null"
                  ]
                }
              }
            }
          }
        }
      DATA
    end

    it 'generates JSON schema' do
      Shale.json_adapter = Shale::Adapter::JSON
      schema = described_class.to_json(ShaleSchemaTesting::Root, pretty: true)
      expect(schema).to eq(expected_json_schema)
    end
  end

  describe '.from_json' do
    context 'without namespace mapping' do
      let(:schema) do
        <<~DATA
          {
            "type": "object",
            "properties": {
              "name": { "type": "string" }
            }
          }
        DATA
      end

      let(:expected_shale_model) do
        <<~DATA
          require 'shale'

          class Foo < Shale::Mapper
            attribute :name, Shale::Type::String

            json do
              map 'name', to: :name
            end
          end
        DATA
      end

      it 'generates Shale models' do
        Shale.json_adapter = Shale::Adapter::JSON
        models = described_class.from_json([schema], root_name: 'foo')
        expect(models.length).to eq(1)
        expect(models).to eq({ 'foo' => expected_shale_model })
      end
    end

    context 'with namespace mapping' do
      let(:schema) do
        <<~DATA
          {
            "$id": "foo",
            "type": "object",
            "properties": {
              "address": { "$ref": "bar" }
            },
            "$defs": {
              "address": {
                "$id": "bar",
                "type": "object",
                "properties": {
                  "city": { "type": "string" }
                }
              }
            }
          }
        DATA
      end

      let(:mapping) do
        { 'foo' => 'foo', 'bar' => 'bar' }
      end

      let(:expected_person) do
        <<~DATA
          require 'shale'

          require_relative '../bar/address'

          module Foo
            class Person < Shale::Mapper
              attribute :address, Bar::Address

              json do
                map 'address', to: :address
              end
            end
          end
        DATA
      end

      let(:expected_address) do
        <<~DATA
          require 'shale'

          module Bar
            class Address < Shale::Mapper
              attribute :city, Shale::Type::String

              json do
                map 'city', to: :city
              end
            end
          end
        DATA
      end

      it 'generates Shale models' do
        Shale.json_adapter = Shale::Adapter::JSON
        models = described_class.from_json(
          [schema],
          root_name: 'Person',
          namespace_mapping: mapping
        )

        expect(models.length).to eq(2)
        expect(models).to eq({
          'foo/person' => expected_person,
          'bar/address' => expected_address,
        })
      end
    end
  end

  describe '.to_xml' do
    let(:expected_xml_schema) do
      schema = <<~DATA.gsub(/\n\z/, '')
        <xs:schema elementFormDefault="qualified" attributeFormDefault="qualified" xmlns:xs="http://www.w3.org/2001/XMLSchema">
          <xs:element name="root" type="ShaleSchemaTesting_Root"/>
          <xs:complexType name="ShaleSchemaTesting_Root">
            <xs:sequence>
              <xs:element name="foo" type="xs:string" minOccurs="0"/>
            </xs:sequence>
          </xs:complexType>
        </xs:schema>
      DATA

      { 'schema0.xsd' => schema }
    end

    it 'generates XML schema' do
      Shale.xml_adapter = Shale::Adapter::REXML
      schemas = described_class.to_xml(ShaleSchemaTesting::Root, pretty: true)
      expect(schemas).to eq(expected_xml_schema)
    end
  end

  describe '.from_xml' do
    context 'elements with periods' do
      let(:schema) do
        <<~SCHEMA
          <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
          <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="foo" targetNamespace="foo">
            <xs:element name="Invoice.Item">
              <xs:complexType>
                <xs:element type="string"/>
              </xs:complexType>
            </xs:element>
            <xs:element name="Root">
              <xs:complexType>
                  <xs:element ref="Invoice.Item"/>
              </xs:complexType>
            </xs:element>
          </xs:schema>
        SCHEMA
      end

      it 'generates Shale models' do
        Shale.xml_adapter = Shale::Adapter::REXML
        models = described_class.from_xml([schema],
          namespace_mapping: { 'foo' => 'Namespace' })
        expect(models.keys).to include('namespace/invoice_item')
        expect(models.keys).to include('namespace/root')
      end
    end

    context 'without namespace mapping' do
      let(:schema) do
        <<~DATA
          <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
            <xs:element name="foo" type="foo" />

            <xs:complexType name="foo">
              <xs:sequence>
                <xs:element name="name" type="xs:string" />
              </xs:sequence>
            </xs:complexType>
          </xs:schema>
        DATA
      end

      let(:expected_shale_model) do
        <<~DATA
          require 'shale'

          class Foo < Shale::Mapper
            attribute :name, Shale::Type::String

            xml do
              root 'foo'

              map_element 'name', to: :name
            end
          end
        DATA
      end

      it 'generates Shale models' do
        Shale.xml_adapter = Shale::Adapter::REXML
        models = described_class.from_xml([schema])
        expect(models.length).to eq(1)
        expect(models).to eq({ 'foo' => expected_shale_model })
      end
    end

    context 'with namespace mapping' do
      let(:schema1) do
        <<~DATA
          <xs:schema
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:foo="foo"
            xmlns:bar="bar"
            targetNamespace="foo"
            elementFormDefault="qualified"
          >
            <xs:import namespace="bar" />

            <xs:element name="Person" type="foo:Person" />

            <xs:complexType name="Person">
              <xs:sequence>
                <xs:element ref="bar:Address" />
              </xs:sequence>
            </xs:complexType>
          </xs:schema>
        DATA
      end

      let(:schema2) do
        <<~DATA
          <xs:schema
            xmlns:xs="http://www.w3.org/2001/XMLSchema"
            xmlns:bar="bar"
            targetNamespace="bar"
            elementFormDefault="qualified"
          >
            <xs:element name="Address" type="bar:Address" />

            <xs:complexType name="Address">
              <xs:sequence>
                <xs:element name="city" type="xs:string" />
              </xs:sequence>
            </xs:complexType>
          </xs:schema>
        DATA
      end

      let(:mapping) do
        { 'foo' => 'foo', 'bar' => 'bar' }
      end

      let(:expected_person) do
        <<~DATA
          require 'shale'

          require_relative '../bar/address'

          module Foo
            class Person < Shale::Mapper
              attribute :address, Bar::Address

              xml do
                root 'Person'
                namespace 'foo', 'foo'

                map_element 'Address', to: :address, prefix: 'bar', namespace: 'bar'
              end
            end
          end
        DATA
      end

      let(:expected_address) do
        <<~DATA
          require 'shale'

          module Bar
            class Address < Shale::Mapper
              attribute :city, Shale::Type::String

              xml do
                root 'Address'
                namespace 'bar', 'bar'

                map_element 'city', to: :city
              end
            end
          end
        DATA
      end

      it 'generates Shale models' do
        Shale.xml_adapter = Shale::Adapter::REXML
        models = described_class.from_xml([schema1, schema2], namespace_mapping: mapping)
        expect(models.length).to eq(2)
        expect(models).to eq({
          'foo/person' => expected_person,
          'bar/address' => expected_address,
        })
      end
    end
  end
end
