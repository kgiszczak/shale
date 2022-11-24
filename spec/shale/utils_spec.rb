# frozen_string_literal: true

require 'shale/utils'

RSpec.describe Shale::Utils do
  describe '.upcase_first' do
    it 'returns value' do
      expect(described_class.upcase_first(nil)).to eq('')
      expect(described_class.upcase_first('')).to eq('')
      expect(described_class.upcase_first('foobar')).to eq('Foobar')
      expect(described_class.upcase_first('fooBar')).to eq('FooBar')
      expect(described_class.upcase_first('FooBar')).to eq('FooBar')
    end
  end

  describe '.classify' do
    it 'returns value' do
      [
        [nil, ''],
        ['', ''],
        %w[foobar Foobar],
        %w[fooBar FooBar],
        %w[foo_bar FooBar],
        %w[Foobar Foobar],
        %w[FooBar FooBar],
        ['packageOne/packageTwo/fooBar', 'PackageOne::PackageTwo::FooBar'],
        ['PackageOne/PackageTwo/FooBar', 'PackageOne::PackageTwo::FooBar'],
        ['Package_One/Package_Two/Foo_Bar', 'PackageOne::PackageTwo::FooBar'],
        ['package_one/package_two/foo_bar', 'PackageOne::PackageTwo::FooBar'],
        ['packageOne::packageTwo::fooBar', 'PackageOne::PackageTwo::FooBar'],
        ['PackageOne::PackageTwo::FooBar', 'PackageOne::PackageTwo::FooBar'],
        ['Package_One::Package_Two::Foo_Bar', 'PackageOne::PackageTwo::FooBar'],
        ['package_one::package_two::foo_bar', 'PackageOne::PackageTwo::FooBar'],
      ].each do |value, expected|
        expect(described_class.classify(value)).to eq(expected)
      end
    end
  end

  describe '.snake_case' do
    it 'returns value' do
      [
        [nil, ''],
        ['', ''],
        %w[foobar foobar],
        %w[fooBar foo_bar],
        %w[foo_bar foo_bar],
        %w[Foobar foobar],
        %w[FooBar foo_bar],
        ['packageOne/packageTwo/fooBar', 'package_one/package_two/foo_bar'],
        ['PackageOne/PackageTwo/FooBar', 'package_one/package_two/foo_bar'],
        ['Package_One/Package_Two/Foo_Bar', 'package_one/package_two/foo_bar'],
        ['package_one/package_two/foo_bar', 'package_one/package_two/foo_bar'],
        ['packageOne::packageTwo::fooBar', 'package_one/package_two/foo_bar'],
        ['PackageOne::PackageTwo::FooBar', 'package_one/package_two/foo_bar'],
        ['Package_One::Package_Two::Foo_Bar', 'package_one/package_two/foo_bar'],
        ['package_one::package_two::foo_bar', 'package_one/package_two/foo_bar'],
      ].each do |value, expected|
        expect(described_class.snake_case(value)).to eq(expected)
      end
    end
  end

  describe '.underscore' do
    it 'converts camel case to underscores' do
      expect(described_class.underscore('FooBar')).to eq('foo_bar')
      expect(described_class.underscore('fooBar')).to eq('foo_bar')
      expect(described_class.underscore('Foo_Bar')).to eq('foo_bar')
      expect(described_class.underscore('Namespace::Foo_Bar')).to(
        eq('foo_bar')
      )
    end
  end

  describe '.presence' do
    it 'returns string or nil if empty' do
      expect(described_class.presence(nil)).to eq(nil)
      expect(described_class.presence('')).to eq(nil)
      expect(described_class.presence('foo')).to eq('foo')
    end
  end
end
