# frozen_string_literal: true

require 'shale/schema/json_compiler/property'
require 'shale/schema/json_compiler/value'

RSpec.describe Shale::Schema::JSONCompiler::Property do
  let(:type) { Shale::Schema::JSONCompiler::Value.new }

  describe '#property_name' do
    it 'returns property name' do
      property = described_class.new('fooBar', type, false, nil)
      expect(property.property_name).to eq('fooBar')
    end
  end

  describe '#attribute_name' do
    it 'returns attribute name' do
      property = described_class.new('fooBar', type, false, nil)
      expect(property.attribute_name).to eq('foo_bar')
    end
  end

  describe '#type' do
    it 'returns type' do
      property = described_class.new('fooBar', type, false, nil)
      expect(property.type).to eq(type)
    end
  end

  describe '#collection?' do
    it 'returns collection' do
      property = described_class.new('fooBar', type, false, nil)
      expect(property.collection?).to eq(false)
    end
  end

  describe '#default' do
    context 'when collection is true' do
      it 'returns nil' do
        property = described_class.new('fooBar', type, true, 'default')
        expect(property.default).to eq(nil)
      end
    end

    context 'when collection is false' do
      context 'when default is a string' do
        it 'returns value' do
          property = described_class.new('fooBar', type, false, 'default\'s')
          expect(property.default).to eq('"default\'s"')
        end
      end

      context 'when default is not a string' do
        it 'returns value' do
          property = described_class.new('fooBar', type, false, 1)
          expect(property.default).to eq(1)
        end
      end
    end
  end
end
