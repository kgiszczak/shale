# frozen_string_literal: true

require 'shale'

RSpec.describe Shale do
  describe '.json_adapter' do
    context 'when adapter is not set' do
      it 'returns default adapter' do
        expect(described_class.json_adapter).to eq(Shale::Adapter::JSON)
      end
    end

    context 'when adapter is set' do
      it 'returns adapter' do
        described_class.json_adapter = :foobar
        expect(described_class.json_adapter).to eq(:foobar)
      end
    end
  end

  describe '.yaml_adapter' do
    context 'when adapter is not set' do
      it 'returns default adapter' do
        expect(described_class.yaml_adapter).to eq(YAML)
      end
    end

    context 'when adapter is set' do
      it 'returns adapter' do
        described_class.yaml_adapter = :foobar
        expect(described_class.yaml_adapter).to eq(:foobar)
      end
    end
  end

  describe '.xml_adapter' do
    context 'when adapter is not set' do
      it 'returns default adapter' do
        expect(described_class.xml_adapter).to eq(Shale::Adapter::REXML)
      end
    end

    context 'when adapter is set' do
      it 'returns adapter' do
        described_class.xml_adapter = :foobar
        expect(described_class.xml_adapter).to eq(:foobar)
      end
    end
  end

  describe '.schema' do
    it 'returns Shale::Schema module' do
      expect(described_class.schema).to eq(Shale::Schema)
    end
  end
end
