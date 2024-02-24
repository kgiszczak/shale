# frozen_string_literal: true

require 'shale/adapter/tomlib'

RSpec.describe Shale::Adapter::Tomlib do
  describe '.load' do
    it 'parses TOML document' do
      doc = described_class.load('foo = "bar"')
      expect(doc).to eq({ 'foo' => 'bar' })
    end

    it 'accepts extra options' do
      doc = described_class.load('foo = "bar"', foo: 'bar')
      expect(doc).to eq({ 'foo' => 'bar' })
    end
  end

  describe '.dump' do
    it 'generates TOML document' do
      toml = described_class.dump({ 'foo' => 'bar' })
      expect(toml).to eq("foo = \"bar\"\n")
    end

    it 'accepts extra options' do
      toml = described_class.dump({ 'foo' => 'bar' }, indent: false)
      expect(toml).to eq("foo = \"bar\"\n")
    end
  end
end
