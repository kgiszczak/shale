# frozen_string_literal: true

require 'shale'
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

      it 'does not raise on floats with a long decimal expansion' do
        expect(described_class.cast(0.1 + 0.2)).to eq(BigDecimal('0.30000000000000004'))
        expect(described_class.cast(1.0 / 3.0)).to eq(BigDecimal('0.3333333333333333'))
        expect(described_class.cast(-(0.1 + 0.2))).to eq(BigDecimal('-0.30000000000000004'))
      end

      it 'preserves the float value' do
        [0.1 + 0.2, 1.0 / 3.0, 14.285714285714286, 2.0, 0.0, 1e300, 5e-324].each do |float|
          expect(described_class.cast(float).to_f).to eq(float)
        end
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

      it 'keeps string precision beyond a float' do
        expect(described_class.cast('0.123456789012345678'))
          .to eq(BigDecimal('0.123456789012345678'))
      end
    end
  end

  it 'is a registered type' do
    expect(Shale::Type.lookup(:decimal)).to eq(described_class)
  end

  context 'through the public JSON API' do
    let(:mapper) do
      Class.new(Shale::Mapper) do
        attribute :value, Shale::Type::Decimal
      end
    end

    it 'parses a high-precision number without raising' do
      obj = mapper.from_json('{"value": 0.30000000000000004}')
      expect(obj.value).to eq(BigDecimal('0.30000000000000004'))
    end

    it 'round-trips a decimal computed from a float' do
      json = mapper.new(value: 0.1 + 0.2).to_json
      expect(mapper.from_json(json).value).to eq(BigDecimal('0.30000000000000004'))
    end
  end
end
