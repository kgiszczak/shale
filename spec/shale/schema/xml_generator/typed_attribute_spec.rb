# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/schema/xml_generator/typed_attribute'

RSpec.describe Shale::Schema::XMLGenerator::TypedAttribute do
  before(:each) do
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  describe '#name' do
    it 'returns name' do
      expect(described_class.new(name: 'foo', type: 'string').name).to eq('foo')
    end
  end

  describe '#as_xml' do
    context 'with default' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(name: 'foo', type: 'string', default: 'bar').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute default="bar" name="foo" type="string"/>')
      end
    end

    context 'without default' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(name: 'foo', type: 'string').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute name="foo" type="string"/>')
      end
    end
  end
end
