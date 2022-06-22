# frozen_string_literal: true

require 'shale/utils'

RSpec.describe Shale::Utils do
  describe '.classify' do
    it 'returns value' do
      expect(described_class.classify(nil)).to eq('')
      expect(described_class.classify('')).to eq('')
      expect(described_class.classify('foobar')).to eq('Foobar')
      expect(described_class.classify('foo_bar')).to eq('FooBar')
      expect(described_class.classify('foo/bar')).to eq('Foo::Bar')
      expect(described_class.classify('Foobar')).to eq('Foobar')
    end
  end

  describe '.snake_case' do
    it 'returns value' do
      expect(described_class.snake_case(nil)).to eq('')
      expect(described_class.snake_case('')).to eq('')
      expect(described_class.snake_case('foobar')).to eq('foobar')
      expect(described_class.snake_case('foo_bar')).to eq('foo_bar')
      expect(described_class.snake_case('FooBar')).to eq('foo_bar')
      expect(described_class.snake_case('fooBar')).to eq('foo_bar')
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
