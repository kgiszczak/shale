# frozen_string_literal: true

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
      schema = described_class.to_json(ShaleSchemaTesting::Root, pretty: true)
      expect(schema).to eq(expected_json_schema)
    end
  end

  describe '.from_json' do
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
      models = described_class.from_json([schema], root_name: 'foo')
      expect(models.length).to eq(1)
      expect(models).to eq({ 'foo' => expected_shale_model })
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
      schemas = described_class.to_xml(ShaleSchemaTesting::Root, pretty: true)
      expect(schemas).to eq(expected_xml_schema)
    end
  end

  describe '.from_xml' do
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
      models = described_class.from_xml([schema])
      expect(models.length).to eq(1)
      expect(models).to eq({ 'foo' => expected_shale_model })
    end
  end
end
