# frozen_string_literal: true

require 'shale/mapping/delegates'

RSpec.describe Shale::Mapping::Delegates::Delegate do
  describe '#receiver_attribute' do
    it 'returns receiver_attribute' do
      expect(described_class.new(:foo, :bar, :baz).receiver_attribute).to eq(:foo)
    end
  end

  describe '#setter' do
    it 'returns setter' do
      expect(described_class.new(:foo, :bar, :baz).setter).to eq(:bar)
    end
  end

  describe '#value' do
    it 'returns value' do
      expect(described_class.new(:foo, :bar, :baz).value).to eq(:baz)
    end
  end
end

RSpec.describe Shale::Mapping::Delegates do
  describe '#add' do
    it 'adds a delegate' do
      obj = described_class.new
      obj.add(:foo, :bar, :baz)

      result = obj.each.to_a
      expect(result.length).to eq(1)
      expect(result[0].receiver_attribute).to eq(:foo)
      expect(result[0].setter).to eq(:bar)
      expect(result[0].value).to eq(:baz)
    end
  end

  describe '#add_collection' do
    it 'adds a delegate' do
      obj = described_class.new
      obj.add_collection(:foo, :bar, :val1)
      obj.add_collection(:foo, :bar, :val2)
      obj.add_collection(:foo, :bar1, :val3)
      obj.add_collection(:foo1, :bar, :val4)

      result = obj.each.to_a
      expect(result.length).to eq(3)
      expect(result[0].receiver_attribute).to eq(:foo)
      expect(result[0].setter).to eq(:bar)
      expect(result[0].value).to eq(%i[val1 val2])
      expect(result[1].receiver_attribute).to eq(:foo)
      expect(result[1].setter).to eq(:bar1)
      expect(result[1].value).to eq([:val3])
      expect(result[2].receiver_attribute).to eq(:foo1)
      expect(result[2].setter).to eq(:bar)
      expect(result[2].value).to eq([:val4])
    end
  end

  describe '#each' do
    it 'iterates over values' do
      obj = described_class.new
      obj.add(:foo1, :bar1, :baz1)
      obj.add(:foo2, :bar2, :baz2)

      result = []

      obj.each do |delegate|
        result << delegate
      end

      expect(result.length).to eq(2)
      expect(result[0].receiver_attribute).to eq(:foo1)
      expect(result[0].setter).to eq(:bar1)
      expect(result[0].value).to eq(:baz1)
      expect(result[1].receiver_attribute).to eq(:foo2)
      expect(result[1].setter).to eq(:bar2)
      expect(result[1].value).to eq(:baz2)
    end
  end
end
