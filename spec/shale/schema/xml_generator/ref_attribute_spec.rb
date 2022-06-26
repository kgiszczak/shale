# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/schema/xml_generator/ref_attribute'

RSpec.describe Shale::Schema::XMLGenerator::RefAttribute do
  before(:each) do
    Shale.xml_adapter = Shale::Adapter::REXML
  end

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
