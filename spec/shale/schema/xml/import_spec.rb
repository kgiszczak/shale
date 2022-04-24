# frozen_string_literal: true

require 'shale'
require 'shale/schema/xml/import'

RSpec.describe Shale::Schema::XML::Import do
  describe '#namespace' do
    it 'returns namespace' do
      expect(described_class.new('foo', 'bar').namespace).to eq('foo')
    end
  end

  describe '#as_xml' do
    context 'with namespace and schema location' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new('foo', 'bar').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:import namespace="foo" schemaLocation="bar"/>')
      end
    end

    context 'without namespace' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(nil, 'bar').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:import schemaLocation="bar"/>')
      end
    end

    context 'without schema location' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new('foo', nil).as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:import namespace="foo"/>')
      end
    end
  end
end
