# frozen_string_literal: true

require 'shale/adapter/json'

RSpec.describe Shale::Adapter::JSON do
  describe '.load' do
    it 'parses JSON document' do
      doc = described_class.load('{"foo": "bar"}')
      expect(doc).to eq({ 'foo' => 'bar' })
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
  end
end
