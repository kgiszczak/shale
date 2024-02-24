# frozen_string_literal: true

require 'shale/adapter/json'

RSpec.describe Shale::Adapter::JSON do
  describe '.load' do
    it 'parses JSON document' do
      doc = described_class.load('{"foo": "bar"}')
      expect(doc).to eq({ 'foo' => 'bar' })
    end

    it 'accepts extra options' do
      doc = described_class.load('{"foo": NaN}', allow_nan: true)
      expect(doc['foo'].nan?).to eq(true)
    end
  end

  describe '.dump' do
    context 'without params' do
      it 'generates JSON document' do
        json = described_class.dump({ 'foo' => 'bar' })
        expect(json).to eq('{"foo":"bar"}')
      end
    end

    context 'with pretty: true param' do
      it 'generates JSON document and formats it' do
        json = described_class.dump({ 'foo' => 'bar' }, pretty: true)
        expected = <<~JSON.gsub(/\n\z/, '')
          {
            "foo": "bar"
          }
        JSON

        expect(json).to eq(expected)
      end
    end

    it 'accepts extra options' do
      json = described_class.dump({ 'foo' => Float::NAN }, allow_nan: true)
      expect(json).to eq('{"foo":NaN}')
    end
  end
end
