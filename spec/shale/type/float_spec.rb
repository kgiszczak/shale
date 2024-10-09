# frozen_string_literal: true

require 'shale/type/float'

RSpec.describe Shale::Type::Float do
  describe '.cast' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.cast(nil)).to eq(nil)
      end
    end

    context 'when value is float' do
      it 'returns value' do
        expect(described_class.cast(123.123)).to eq(123.123)
      end
    end

    context 'when value is Infinity' do
      it 'returns float number' do
        expect(described_class.cast('Infinity')).to eq(Float::INFINITY)
      end
    end

    context 'when value is -Infinity' do
      it 'returns float number' do
        expect(described_class.cast('-Infinity')).to eq(-Float::INFINITY)
      end
    end

    context 'when value is NaN' do
      it 'returns float NaN' do
        expect(described_class.cast('NaN').nan?).to eq(true)
      end
    end

    context 'when value is anything other' do
      it 'returns float value' do
        expect(described_class.cast('123.123')).to eq(123.123)
      end
    end
  end

  it 'is a registered type' do
    expect(Shale::Type.lookup(:float)).to eq(described_class)
  end
end
