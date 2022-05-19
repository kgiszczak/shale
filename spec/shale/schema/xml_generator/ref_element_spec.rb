# frozen_string_literal: true

require 'shale'
require 'shale/schema/xml_generator/ref_element'

RSpec.describe Shale::Schema::XMLGenerator::RefElement do
  describe '#as_xml' do
    context 'with default' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(ref: 'foo', default: 'bar').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:element default="bar" minOccurs="0" ref="foo"/>')
      end
    end

    context 'with collection' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(ref: 'foo', collection: true).as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:element maxOccurs="unbounded" minOccurs="0" ref="foo"/>')
      end
    end

    context 'with required' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(ref: 'foo', required: true).as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:element ref="foo"/>')
      end
    end

    context 'without modifiers' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(ref: 'foo').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:element minOccurs="0" ref="foo"/>')
      end
    end
  end
end
