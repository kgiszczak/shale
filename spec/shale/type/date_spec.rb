# frozen_string_literal: true

require 'shale/type/date'

RSpec.describe Shale::Type::Date do
  describe '.cast' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.cast(nil)).to eq(nil)
      end
    end

    context 'when value is empty string' do
      it 'returns nil' do
        expect(described_class.cast('')).to eq(nil)
      end
    end

    context 'when value is date string' do
      it 'returns date' do
        expect(described_class.cast('2021-01-01')).to eq(Date.new(2021, 1, 1))
      end
    end

    context 'when value responds to to_date' do
      it 'returns date' do
        time = Time.new(2021, 1, 1)
        expect(described_class.cast(time)).to eq(Date.new(2021, 1, 1))
      end
    end

    context 'when any other value' do
      it 'returns value' do
        expect(described_class.cast(123)).to eq(123)
      end
    end
  end
end
