# frozen_string_literal: true

require 'shale/type/decimal'

RSpec.describe Shale::Type::Decimal do
  describe '.cast' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.cast(nil)).to eq(nil)
      end
    end

    context 'when value is float' do
      it 'returns BigDecimal number' do
        expect(described_class.cast(123.123)).to eq(BigDecimal('123.123'))
        expect(described_class.cast(123.33)).to eq(BigDecimal('123.33'))
      end
    end

    context 'when value is Infinity' do
      it 'returns BigDecimal number' do
        expect(described_class.cast('Infinity')).to eq(BigDecimal('Infinity'))
      end
    end

    context 'when value is -Infinity' do
      it 'returns BigDecimal number' do
        expect(described_class.cast('-Infinity')).to eq(BigDecimal('-Infinity'))
      end
    end

    context 'when value is NaN' do
      it 'returns BigDecimal NaN' do
        expect(described_class.cast('NaN').nan?).to eq(true)
      end
    end

    context 'when value is anything other' do
      it 'returns BigDecimal value' do
        expect(described_class.cast('123.123')).to eq(BigDecimal('123.123'))
      end
    end
  end

  it 'is a registered type' do
    expect(Shale::Type.lookup(:decimal)).to eq(described_class)
  end
end
