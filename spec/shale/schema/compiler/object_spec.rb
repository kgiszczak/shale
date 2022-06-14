# frozen_string_literal: true

require 'shale/schema/compiler/object'
require 'shale/schema/compiler/property'
require 'shale/schema/compiler/value'

RSpec.describe Shale::Schema::Compiler::Object do
  let(:type) { Shale::Schema::Compiler::Value.new }

  describe '#id' do
    it 'returns value' do
      object = described_class.new('foobar-id', 'foobar')
      expect(object.id).to eq('foobar-id')
    end
  end

  describe '#properties' do
    it 'returns value' do
      property = Shale::Schema::Compiler::Property.new('fooBar', type, false, nil)

      object = described_class.new('foobar-id', 'foobar')
      object.add_property(property)

      expect(object.properties).to eq([property])
    end
  end

  describe '#name=' do
    it 'sets the value' do
      object = described_class.new('foobar-id', 'foobar')
      object.name = 'barfoo'
      expect(object.name).to eq('Barfoo')
    end
  end

  describe '#name' do
    it 'returns the value' do
      object = described_class.new('foobar-id', 'foobar')
      expect(object.name).to eq('Foobar')
    end
  end

  describe '#file_name' do
    it 'returns the value' do
      object = described_class.new('foobar-id', 'fooBar')
      expect(object.file_name).to eq('foo_bar')
    end
  end

  describe '#references' do
    it 'returns properties with Object type' do
      property1 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)

      object1 = described_class.new('id1', 'foo1')
      property2 = Shale::Schema::Compiler::Property.new('fooBar2', object1, false, nil)

      object = described_class.new('id', 'foo')
      property3 = Shale::Schema::Compiler::Property.new('fooBar2', object, false, nil)

      object.add_property(property1)
      object.add_property(property2)
      object.add_property(property3)
      object.add_property(property2)

      expect(object.references).to eq([property2])
    end
  end

  describe '#add_property' do
    it 'returns value' do
      property1 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)
      property2 = Shale::Schema::Compiler::Property.new('fooBar2', type, false, nil)

      object = described_class.new('foobar-id', 'foobar')
      expect(object.properties.length).to eq(0)

      object.add_property(property1)
      expect(object.properties.length).to eq(1)

      object.add_property(property2)
      expect(object.properties.length).to eq(2)
    end
  end
end
