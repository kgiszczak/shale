# frozen_string_literal: true

require 'shale/attribute'

RSpec.describe Shale::Attribute do
  describe '#name' do
    it 'returns attribute value' do
      expect(described_class.new('foo', 'bar', false, nil, nil, nil, nil).name).to eq('foo')
    end
  end

  describe '#setter' do
    it "returns attribute's setter name" do
      expect(described_class.new('foo', 'bar', false, nil, nil, nil, nil).setter).to eq('foo=')
    end
  end

  describe '#type' do
    it 'returns attribute value' do
      expect(described_class.new('foo', 'bar', false, nil, nil, nil, nil).type).to eq('bar')
    end
  end

  describe '#default' do
    context 'when collection is false' do
      it 'returns passed default' do
        attribute = described_class.new('foo', 'bar', false, :default, nil, nil, nil)
        expect(attribute.default).to eq(:default)
      end
    end

    context 'when collection is true' do
      it 'returns array default' do
        attribute = described_class.new('foo', 'bar', true, :default, nil, nil, nil)
        expect(attribute.default.call).to eq([])
      end
    end
  end

  describe '#collection?' do
    context 'when collection is false' do
      it 'returns false' do
        attribute = described_class.new('foo', 'bar', false, nil, nil, nil, nil)
        expect(attribute.collection?).to eq(false)
      end
    end

    context 'when collection is true' do
      it 'returns true' do
        attribute = described_class.new('foo', 'bar', true, nil, nil, nil, nil)
        expect(attribute.collection?).to eq(true)
      end
    end
  end
end
