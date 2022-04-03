# frozen_string_literal: true

require 'shale/mapping/descriptor/xml_namespace'

RSpec.describe Shale::Mapping::Descriptor::XmlNamespace do
  describe '#name' do
    it 'returns name' do
      obj = described_class.new('foo', 'bar')
      expect(obj.name).to eq('foo')
    end
  end

  describe '#prefix' do
    it 'returns prefix' do
      obj = described_class.new('foo', 'bar')
      expect(obj.prefix).to eq('bar')
    end
  end
end
