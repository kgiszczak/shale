# frozen_string_literal: true

require 'shale/mapping/group/dict'

RSpec.describe Shale::Mapping::Group::Dict do
  describe '#method_from' do
    it 'returns a symbol' do
      result = described_class.new(:foo, :bar)
      expect(result.method_from).to eq(:foo)
    end
  end

  describe '#method_to' do
    it 'returns a symbol' do
      result = described_class.new(:foo, :bar)
      expect(result.method_to).to eq(:bar)
    end
  end

  describe '#dict' do
    it 'returns a hash' do
      result = described_class.new(:foo, :bar)
      expect(result.dict).to eq({})
    end
  end

  describe '#add' do
    it 'adds a pair to a dict' do
      result = described_class.new(:foo, :bar)
      result.add('key1', 1)
      result.add('key2', 2)

      expect(result.dict).to eq({ 'key1' => 1, 'key2' => 2 })
    end
  end
end
