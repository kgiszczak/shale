# frozen_string_literal: true

require 'shale/type/boolean'

RSpec.describe Shale::Type::Boolean do
  describe '.cast' do
    let(:false_values) do
      [
        false,
        0,
        '0',
        'f',
        'F',
        'false',
        'FALSE',
        'off',
        'OFF',
      ]
    end

    context 'when false values include value' do
      it 'returns false' do
        false_values.each do |val|
          expect(described_class.cast(val)).to eq(false)
        end
      end
    end

    context 'when false values do not include value' do
      it 'returns true' do
        expect(described_class.cast('')).to eq(true)
      end
    end
  end

  it 'is a registered type' do
    expect(Shale::Type.lookup(:boolean)).to eq(described_class)
  end
end
