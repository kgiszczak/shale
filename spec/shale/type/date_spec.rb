# frozen_string_literal: true

require 'shale/adapter/rexml'
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

  describe '.as_json' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.as_json(nil)).to eq(nil)
      end
    end

    context 'when value is present' do
      it 'returns ISO formatted date' do
        date = Date.new(2021, 1, 1)
        expect(described_class.as_json(date)).to eq('2021-01-01')
      end
    end

    context 'with extra params' do
      it 'returns ISO formatted date' do
        date = Date.new(2021, 1, 1)
        expect(described_class.as_json(date, context: nil)).to eq('2021-01-01')
      end
    end
  end

  describe '.as_yaml' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.as_yaml(nil)).to eq(nil)
      end
    end

    context 'when value is present' do
      it 'returns ISO formatted date' do
        date = Date.new(2021, 1, 1)
        expect(described_class.as_yaml(date)).to eq('2021-01-01')
      end
    end

    context 'with extra params' do
      it 'returns ISO formatted date' do
        date = Date.new(2021, 1, 1)
        expect(described_class.as_yaml(date, context: nil)).to eq('2021-01-01')
      end
    end
  end

  describe '.as_csv' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.as_csv(nil)).to eq(nil)
      end
    end

    context 'when value is present' do
      it 'returns ISO formatted date' do
        date = Date.new(2021, 1, 1)
        expect(described_class.as_csv(date)).to eq('2021-01-01')
      end
    end

    context 'with extra params' do
      it 'returns ISO formatted date' do
        date = Date.new(2021, 1, 1)
        expect(described_class.as_csv(date, context: nil)).to eq('2021-01-01')
      end
    end
  end

  describe '.as_xml_value' do
    context 'when value is nil' do
      it 'returns nil' do
        expect(described_class.as_xml_value(nil)).to eq(nil)
      end
    end

    context 'when value is present' do
      it 'returns ISO formatted date' do
        date = Date.new(2021, 1, 1)
        expect(described_class.as_xml_value(date)).to eq('2021-01-01')
      end
    end
  end

  describe '.as_xml' do
    context 'when value is nil' do
      it 'converts text to XML node' do
        doc = Shale::Adapter::REXML.create_document
        res = described_class.as_xml(nil, 'foobar', doc).to_s
        expect(res).to eq('<foobar/>')
      end
    end

    context 'when value is present' do
      it 'converts text to XML node' do
        date = Date.new(2021, 1, 1)
        doc = Shale::Adapter::REXML.create_document
        res = described_class.as_xml(date, 'foobar', doc).to_s
        expect(res).to eq('<foobar>2021-01-01</foobar>')
      end
    end
  end

  it 'is a registered type' do
    expect(Shale::Type.lookup(:date)).to eq(described_class)
  end
end
