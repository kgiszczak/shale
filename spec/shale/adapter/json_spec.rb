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
    it 'generates JSON document' do
      json = described_class.dump('foo' => 'bar')
      expect(json).to eq('{"foo":"bar"}')
    end
  end
end
