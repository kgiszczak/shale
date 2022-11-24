# frozen_string_literal: true

require 'shale/schema/compiler/xml_complex'

RSpec.describe Shale::Schema::Compiler::XMLComplex do
  describe '#root=' do
    it 'sets the value' do
      complex = described_class.new('foobar-id', 'foobar', nil, nil, nil)
      complex.root = 'barfoo'
      expect(complex.root).to eq('barfoo')
    end
  end

  describe '#root' do
    it 'returns the value' do
      complex = described_class.new('foobar-id', 'foobar', nil, nil, nil)
      expect(complex.root).to eq('foobar')
    end
  end

  describe '#prefix' do
    it 'returns the value' do
      complex = described_class.new('foobar-id', 'foobar', 'foo', 'bar', nil)
      expect(complex.prefix).to eq('foo')
    end
  end

  describe '#namespace' do
    it 'returns the value' do
      complex = described_class.new('foobar-id', 'foobar', 'foo', 'bar', nil)
      expect(complex.namespace).to eq('bar')
    end
  end

  describe '#initialize' do
    it 'intializes base class with values' do
      complex = described_class.new('foobar-id', 'foobar', 'foo', 'bar', 'foo/bar')
      expect(complex.id).to eq('foobar-id')
      expect(complex.root_name).to eq('Foobar')
      expect(complex.modules).to eq(%w[Foo Bar])
    end
  end
end
