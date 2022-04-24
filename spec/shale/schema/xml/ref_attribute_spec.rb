# frozen_string_literal: true

require 'shale'
require 'shale/schema/xml/ref_attribute'

RSpec.describe Shale::Schema::XML::RefAttribute do
  describe '#as_xml' do
    context 'with default' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(ref: 'foo', default: 'bar').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute default="bar" ref="foo"/>')
      end
    end

    context 'without default' do
      it 'returns XML node' do
        doc = Shale.xml_adapter.create_document
        el = described_class.new(ref: 'foo').as_xml(doc)
        result = Shale.xml_adapter.dump(el)

        expect(result).to eq('<xs:attribute ref="foo"/>')
      end
    end
  end
end
