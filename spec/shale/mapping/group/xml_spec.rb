# frozen_string_literal: true

require 'shale/mapping/group/xml'

RSpec.describe Shale::Mapping::Group::Xml do
  describe '#add' do
    context 'when kind is set to :content' do
      it 'adds a pair to a dict' do
        result = described_class.new(:foo, :bar)
        result.add(:content, 'key1', 1)

        expect(result.dict[:content]).to eq(1)
      end
    end

    context 'when kind is set to :attribute' do
      it 'adds a pair to a dict' do
        result = described_class.new(:foo, :bar)
        result.add(:attribute, 'key1', 1)
        result.add(:attribute, 'key2', 2)

        expect(result.dict[:attributes]).to eq({ 'key1' => 1, 'key2' => 2 })
      end
    end

    context 'when kind is set to :element' do
      it 'adds a pair to a dict' do
        result = described_class.new(:foo, :bar)
        result.add(:element, 'key1', 1)
        result.add(:element, 'key2', 2)

        expect(result.dict[:elements]).to eq({ 'key1' => 1, 'key2' => 2 })
      end
    end

    context 'when kind is set to other value' do
      it 'does not add a pair to a dict' do
        result = described_class.new(:foo, :bar)
        result.add(:foo, 'key1', 1)
        result.add(:bar, 'key2', 2)

        expect(result.dict).to eq({ content: nil, attributes: {}, elements: {} })
      end
    end
  end
end
