# frozen_string_literal: true

require 'shale/type/base'
require 'shale/adapter/rexml'
require 'rexml/document'

RSpec.describe Shale::Type::Base do
  describe '.cast' do
    it 'returns value' do
      expect(described_class.cast(123)).to eq(123)
    end
  end

  describe '.out_of_hash' do
    it 'returns value' do
      expect(described_class.out_of_hash(123)).to eq(123)
    end
  end

  describe '.as_hash' do
    it 'returns value' do
      expect(described_class.as_hash(123)).to eq(123)
    end
  end

  describe '.out_of_json' do
    it 'returns value' do
      expect(described_class.out_of_json(123)).to eq(123)
    end
  end

  describe '.as_json' do
    it 'returns value' do
      expect(described_class.as_json(123)).to eq(123)
    end
  end

  describe '.out_of_yaml' do
    it 'returns value' do
      expect(described_class.out_of_yaml(123)).to eq(123)
    end
  end

  describe '.as_yaml' do
    it 'returns value' do
      expect(described_class.as_yaml(123)).to eq(123)
    end
  end

  describe '.out_of_xml' do
    it 'extracts text from XML node' do
      element = ::REXML::Element.new('name')
      element.add_text('foobar')

      node = Shale::Adapter::REXML::Node.new(element)

      expect(described_class.out_of_xml(node)).to eq('foobar')
    end
  end

  describe '.as_xml' do
    it 'converts text to XML node' do
      doc = Shale::Adapter::REXML.create_document
      res = described_class.as_xml(123, 'foobar', doc).to_s
      expect(res).to eq('<foobar>123</foobar>')
    end
  end
end
