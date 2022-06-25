# frozen_string_literal: true

require 'shale/schema/compiler/value'
require 'shale/schema/compiler/xml_property'

RSpec.describe Shale::Schema::Compiler::XMLProperty do
  let(:type) { Shale::Schema::Compiler::Value.new }

  describe '#prefix' do
    it 'returns the value' do
      complex = described_class.new(
        name: 'foobar',
        type: type,
        collection: false,
        default: nil,
        prefix: 'foo',
        namespace: 'bar',
        category: :element
      )
      expect(complex.prefix).to eq('foo')
    end
  end

  describe '#namespace' do
    it 'returns the value' do
      complex = described_class.new(
        name: 'foobar',
        type: type,
        collection: false,
        default: nil,
        prefix: 'foo',
        namespace: 'bar',
        category: :element
      )
      expect(complex.namespace).to eq('bar')
    end
  end

  describe '#content?' do
    context 'when category is :content' do
      it 'returns true' do
        complex = described_class.new(
          name: 'foobar',
          type: type,
          collection: false,
          default: nil,
          prefix: 'foo',
          namespace: 'bar',
          category: :content
        )
        expect(complex.content?).to eq(true)
      end
    end

    context 'when category is not :content' do
      it 'returns true' do
        complex = described_class.new(
          name: 'foobar',
          type: type,
          collection: false,
          default: nil,
          prefix: 'foo',
          namespace: 'bar',
          category: :element
        )
        expect(complex.content?).to eq(false)
      end
    end
  end

  describe '#attribute?' do
    context 'when category is :attribute' do
      it 'returns true' do
        complex = described_class.new(
          name: 'foobar',
          type: type,
          collection: false,
          default: nil,
          prefix: 'foo',
          namespace: 'bar',
          category: :attribute
        )
        expect(complex.attribute?).to eq(true)
      end
    end

    context 'when category is not :attribute' do
      it 'returns true' do
        complex = described_class.new(
          name: 'foobar',
          type: type,
          collection: false,
          default: nil,
          prefix: 'foo',
          namespace: 'bar',
          category: :element
        )
        expect(complex.attribute?).to eq(false)
      end
    end
  end

  describe '#element?' do
    context 'when category is :element' do
      it 'returns true' do
        complex = described_class.new(
          name: 'foobar',
          type: type,
          collection: false,
          default: nil,
          prefix: 'foo',
          namespace: 'bar',
          category: :element
        )
        expect(complex.element?).to eq(true)
      end
    end

    context 'when category is not :element' do
      it 'returns true' do
        complex = described_class.new(
          name: 'foobar',
          type: type,
          collection: false,
          default: nil,
          prefix: 'foo',
          namespace: 'bar',
          category: :content
        )
        expect(complex.element?).to eq(false)
      end
    end
  end
end
