# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/schema/xml_generator/complex_type'
require 'shale/schema/xml_generator/typed_attribute'
require 'shale/schema/xml_generator/typed_element'

RSpec.describe Shale::Schema::XMLGenerator::ComplexType do
  before(:each) do
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  describe '#name' do
    it 'returns namespace' do
      expect(described_class.new('foo').name).to eq('foo')
    end
  end

  describe '#as_xml' do
    context 'when children is empty' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new('foo').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:complexType name="foo"/>')
      end
    end

    context 'with mixed set to true' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new('foo', [], mixed: true).as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:complexType mixed="true" name="foo"/>')
      end
    end

    context 'with schildren present' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document

        children = [
          Shale::Schema::XMLGenerator::TypedElement.new(name: 'foo', type: 'string'),
          Shale::Schema::XMLGenerator::TypedAttribute.new(name: 'bar', type: 'string'),
        ]
        el = described_class.new('foo', children).as_xml(doc)

        result = Shale.xml_adapter.dump(el)

        expected = <<~XML.gsub("\n", '').gsub(/\s{2,}/, '')
          <xs:complexType name="foo">
            <xs:sequence>
              <xs:element minOccurs="0" name="foo" type="string"/>
            </xs:sequence>
            <xs:attribute name="bar" type="string"/>
          </xs:complexType>
        XML

        expect(result).to eq(expected)
      end
    end
  end
end
