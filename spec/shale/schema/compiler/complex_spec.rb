# frozen_string_literal: true

require 'shale/schema/compiler/complex'
require 'shale/schema/compiler/property'
require 'shale/schema/compiler/value'

RSpec.describe Shale::Schema::Compiler::Complex do
  let(:type) { Shale::Schema::Compiler::Value.new }

  describe '#id' do
    it 'returns value' do
      complex = described_class.new('foobar-id', 'foobar')
      expect(complex.id).to eq('foobar-id')
    end
  end

  describe '#properties' do
    it 'returns value' do
      property = Shale::Schema::Compiler::Property.new('fooBar', type, false, nil)

      complex = described_class.new('foobar-id', 'foobar')
      complex.add_property(property)

      expect(complex.properties).to eq([property])
    end
  end

  describe '#name=' do
    it 'sets the value' do
      complex = described_class.new('foobar-id', 'foobar')
      complex.name = 'barfoo'
      expect(complex.name).to eq('Barfoo')
    end
  end

  describe '#name' do
    it 'returns the value' do
      complex = described_class.new('foobar-id', 'foobar')
      expect(complex.name).to eq('Foobar')
    end
  end

  describe '#file_name' do
    it 'returns the value' do
      complex = described_class.new('foobar-id', 'fooBar')
      expect(complex.file_name).to eq('foo_bar')
    end
  end

  describe '#references' do
    it 'returns properties with Complex type' do
      property1 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)

      complex1 = described_class.new('id1', 'foo1')
      property2 = Shale::Schema::Compiler::Property.new('fooBar2', complex1, false, nil)

      complex = described_class.new('id', 'foo')
      property3 = Shale::Schema::Compiler::Property.new('fooBar2', complex, false, nil)

      complex.add_property(property1)
      complex.add_property(property2)
      complex.add_property(property3)
      complex.add_property(property2)

      expect(complex.references).to eq([property2])
    end
  end

  describe '#add_property' do
    it 'returns value' do
      property1 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)
      property2 = Shale::Schema::Compiler::Property.new('fooBar2', type, false, nil)

      complex = described_class.new('foobar-id', 'foobar')
      expect(complex.properties.length).to eq(0)

      complex.add_property(property1)
      expect(complex.properties.length).to eq(1)

      complex.add_property(property2)
      expect(complex.properties.length).to eq(2)
    end
  end
end
