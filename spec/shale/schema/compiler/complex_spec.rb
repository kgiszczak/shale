# frozen_string_literal: true

require 'shale/schema/compiler/complex'
require 'shale/schema/compiler/property'
require 'shale/schema/compiler/value'

RSpec.describe Shale::Schema::Compiler::Complex do
  let(:type) { Shale::Schema::Compiler::Value.new }

  describe '#id' do
    it 'returns value' do
      complex = described_class.new('foobar-id', 'foobar', nil)
      expect(complex.id).to eq('foobar-id')
    end
  end

  describe '#properties' do
    it 'returns value' do
      property = Shale::Schema::Compiler::Property.new('fooBar', type, false, nil)

      complex = described_class.new('foobar-id', 'foobar', nil)
      complex.add_property(property)

      expect(complex.properties).to eq([property])
    end
  end

  describe '#root_name=' do
    context 'when package is not present' do
      it 'sets the value' do
        complex = described_class.new('foobar-id', 'foobar', nil)
        complex.root_name = 'barfoo'
        expect(complex.root_name).to eq('Barfoo')
      end
    end

    context 'when package is present' do
      it 'sets the value' do
        complex = described_class.new('foobar-id', 'foobar', 'package')
        complex.root_name = 'barfoo'
        expect(complex.root_name).to eq('Barfoo')
      end
    end
  end

  describe '#root_name' do
    context 'when package is not present' do
      it 'returns the value' do
        complex = described_class.new('foobar-id', 'foobar', nil)
        expect(complex.root_name).to eq('Foobar')
      end
    end

    context 'when package is present' do
      it 'returns the value' do
        complex = described_class.new('foobar-id', 'foobar', 'package')
        expect(complex.root_name).to eq('Foobar')
      end
    end
  end

  describe '#name' do
    context 'when package is not present' do
      it 'returns the value' do
        complex = described_class.new('foobar-id', 'foobar', nil)
        expect(complex.name).to eq('Foobar')
      end
    end

    context 'when package is present' do
      it 'returns the value' do
        complex = described_class.new('foobar-id', 'foobar', 'package')
        expect(complex.name).to eq('Package::Foobar')
      end
    end
  end

  describe '#modules' do
    context 'when package is not present' do
      it 'returns the value' do
        complex = described_class.new('foobar-id', 'foobar', nil)
        expect(complex.modules).to eq([])
      end
    end

    context 'when package is present' do
      it 'returns the value' do
        complex1 = described_class.new('foobar-id', 'foobar', 'package_one::package_two')
        complex2 = described_class.new('foobar-id', 'foobar', 'package_one/package_two')
        complex3 = described_class.new('foobar-id', 'foobar', 'package_one/packageTwo')

        expect(complex1.modules).to eq(%w[PackageOne PackageTwo])
        expect(complex2.modules).to eq(%w[PackageOne PackageTwo])
        expect(complex3.modules).to eq(%w[PackageOne PackageTwo])
      end
    end
  end

  describe '#file_name' do
    context 'when package is not present' do
      it 'returns the value' do
        complex = described_class.new('foobar-id', 'fooBar', nil)
        expect(complex.file_name).to eq('foo_bar')
      end
    end

    context 'when package is present' do
      it 'returns the value' do
        complex = described_class.new('foobar-id', 'fooBar', 'PackageOne::PackageTwo')
        expect(complex.file_name).to eq('package_one/package_two/foo_bar')
      end
    end

    context 'a period is present in the root_name and id' do
      it 'returns the value' do
        complex = described_class.new('Foo.Bar:http://www.example.com', 'Foo.Bar', 'PackageOne::PackageTwo')
        expect(complex.file_name).to eq('package_one/package_two/foo_bar')
      end
    end
  end

  describe '#relative_path' do
    it 'returns relative path between two files' do
      [
        [nil, 'address', 'address'],
        [nil, 'foo/address', 'foo/address'],
        ['bar', 'address', '../address'],
        ['bar', 'foo/address', '../foo/address'],
        ['foo', 'foo/address', 'address'],
        ['foo/bar', 'foo/bar/address', 'address'],
        ['foo/bar', 'foo/baz/address', '../baz/address'],
        ['foo/bar', 'baq/baz/address', '../../baq/baz/address'],
      ].each do |package, other, expected|
        result = described_class.new('foobar-id', 'person', package).relative_path(other)
        expect(result).to eq(expected)
      end
    end
  end

  describe '#references' do
    it 'returns properties with Complex type' do
      property1 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)

      complex1 = described_class.new('id1', 'foo1', nil)
      property2 = Shale::Schema::Compiler::Property.new('fooBar2', complex1, false, nil)

      complex = described_class.new('id', 'foo', nil)
      property3 = Shale::Schema::Compiler::Property.new('fooBar2', complex, false, nil)

      complex.add_property(property1)
      complex.add_property(property2)
      complex.add_property(property3)
      complex.add_property(property2)

      expect(complex.references).to eq([property2])
    end

    it 'sorts references by file_name' do
      complex = described_class.new('id', 'foo', nil)

      complex1 = described_class.new('id1', 'a', nil)
      property1 = Shale::Schema::Compiler::Property.new('prop1', complex1, false, nil)

      complex2 = described_class.new('id2', 'b', nil)
      property2 = Shale::Schema::Compiler::Property.new('prop2', complex2, false, nil)

      complex3 = described_class.new('id3', 'c', nil)
      property3 = Shale::Schema::Compiler::Property.new('prop3', complex3, false, nil)

      complex4 = described_class.new('id4', 'd', nil)
      property4 = Shale::Schema::Compiler::Property.new('prop4', complex4, false, nil)

      complex.add_property(property2)
      complex.add_property(property1)
      complex.add_property(property4)
      complex.add_property(property3)

      expect(complex.references).to eq([property1, property2, property3, property4])
    end

    it 'returns uniq references' do
      complex = described_class.new('id', 'foo', nil)

      complex1 = described_class.new('id1', 'a', nil)
      property1 = Shale::Schema::Compiler::Property.new('prop1', complex1, false, nil)
      property2 = Shale::Schema::Compiler::Property.new('prop2', complex1, false, nil)

      complex2 = described_class.new('id2', 'b', nil)
      property3 = Shale::Schema::Compiler::Property.new('prop3', complex2, false, nil)
      property4 = Shale::Schema::Compiler::Property.new('prop4', complex2, false, nil)

      complex.add_property(property2)
      complex.add_property(property1)
      complex.add_property(property4)
      complex.add_property(property3)

      expect(complex.references).to eq([property2, property4])
    end
  end

  describe '#add_property' do
    context 'when property with given name is not present' do
      it 'adds property' do
        property1 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)
        property2 = Shale::Schema::Compiler::Property.new('fooBar2', type, false, nil)

        complex = described_class.new('foobar-id', 'foobar', nil)
        expect(complex.properties.length).to eq(0)

        complex.add_property(property1)
        expect(complex.properties.length).to eq(1)

        complex.add_property(property2)
        expect(complex.properties.length).to eq(2)
      end
    end

    context 'when proeprty with given name is already present' do
      it 'adds property' do
        property1 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)
        property2 = Shale::Schema::Compiler::Property.new('fooBar1', type, false, nil)

        complex = described_class.new('foobar-id', 'foobar', nil)
        expect(complex.properties.length).to eq(0)

        complex.add_property(property1)
        expect(complex.properties.length).to eq(1)

        complex.add_property(property2)
        expect(complex.properties.length).to eq(1)
        expect(complex.properties[0].mapping_name).to eq('fooBar1')
      end
    end
  end
end
