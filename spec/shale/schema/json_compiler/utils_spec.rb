# frozen_string_literal: true

require 'shale/schema/json_compiler/utils'

RSpec.describe Shale::Schema::JSONCompiler::Utils do
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
end
