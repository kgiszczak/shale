# frozen_string_literal: true

require 'shale/adapter/rexml'
require 'shale/type/time'

RSpec.describe Shale::Type::Time do
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

    context 'when value is time string' do
      it 'returns time' do
        expected = Time.new(2021, 1, 1, 10, 10, 10)
        expect(described_class.cast('2021-01-01 10:10:10')).to eq(expected)
      end
    end

    context 'when value responds to to_time' do
      it 'returns time' do
        time = Time.new(2021, 1, 1, 10, 10, 10)
        expected = Time.new(2021, 1, 1, 10, 10, 10)
        expect(described_class.cast(time)).to eq(expected)
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
      it 'returns ISO formatted time' do
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        expect(described_class.as_json(time)).to eq('2021-01-01T10:10:10+01:00')
      end
    end

    context 'with extra params' do
      it 'returns ISO formatted time' do
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        expect(described_class.as_json(time, context: nil)).to eq('2021-01-01T10:10:10+01:00')
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
      it 'returns ISO formatted time' do
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        expect(described_class.as_yaml(time)).to eq('2021-01-01T10:10:10+01:00')
      end
    end

    context 'with extra params' do
      it 'returns ISO formatted time' do
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        expect(described_class.as_yaml(time, context: nil)).to eq('2021-01-01T10:10:10+01:00')
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
      it 'returns ISO formatted time' do
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        expect(described_class.as_csv(time)).to eq('2021-01-01T10:10:10+01:00')
      end
    end

    context 'with extra params' do
      it 'returns ISO formatted time' do
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        expect(described_class.as_csv(time, context: nil)).to eq('2021-01-01T10:10:10+01:00')
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
      it 'returns ISO formatted time' do
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        expect(described_class.as_xml_value(time)).to eq('2021-01-01T10:10:10+01:00')
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
        time = Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
        doc = Shale::Adapter::REXML.create_document
        res = described_class.as_xml(time, 'foobar', doc).to_s
        expect(res).to eq('<foobar>2021-01-01T10:10:10+01:00</foobar>')
      end
    end
  end

  it 'is a registered type' do
    expect(Shale::Type.lookup(:time)).to eq(described_class)
  end
end
