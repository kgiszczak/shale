# frozen_string_literal: true

require 'shale/mapping/descriptor'

RSpec.describe Shale::Mapping::Descriptor do
  describe '#name' do
    it 'returns name' do
      obj = described_class.new(name: 'foo', attribute: :bar, methods: nil)
      expect(obj.name).to eq('foo')
    end
  end

  describe '#attribute' do
    context 'when attribute is set' do
      it 'returns attribute' do
        obj = described_class.new(name: 'foo', attribute: :bar, methods: nil)
        expect(obj.attribute).to eq(:bar)
      end
    end

    context 'when attribute is not set' do
      it 'returns nil' do
        obj = described_class.new(name: 'foo', attribute: nil, methods: nil)
        expect(obj.attribute).to eq(nil)
      end
    end
  end

  describe '#method_from' do
    context 'when object was initialized with methods argument' do
      it 'returns method_from' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: { from: :met_from, to: :met_to }
        )
        expect(obj.method_from).to eq(:met_from)
      end
    end

    context 'when object was initialized without methods argument' do
      it 'returns nil' do
        obj = described_class.new(name: 'foo', attribute: :bar, methods: nil)
        expect(obj.method_from).to eq(nil)
      end
    end
  end

  describe '#method_to' do
    context 'when object was initialized with methods argument' do
      it 'returns method_to' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: { from: :met_from, to: :met_to }
        )
        expect(obj.method_to).to eq(:met_to)
      end
    end

    context 'when object was initialized without methods argument' do
      it 'returns nil' do
        obj = described_class.new(name: 'foo', attribute: :bar, methods: nil)
        expect(obj.method_to).to eq(nil)
      end
    end
  end
end
