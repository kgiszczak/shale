# frozen_string_literal: true

require 'shale/type/complex'
require 'shale/mapper'

module ShaleComplexTesting
  class ComplexType < Shale::Mapper
    attribute :complex_attr1, Shale::Type::String

    hash do
      map 'complex_attr1', to: :complex_attr1
    end

    json do
      map 'complex_attr1', to: :complex_attr1
    end

    yaml do
      map 'complex_attr1', to: :complex_attr1
    end

    xml do
      root 'comlex_type'
      map_content to: :complex_attr1
    end
  end

  class RootType < Shale::Mapper
    attribute :root_attr1, Shale::Type::String
    attribute :root_attr2, Shale::Type::String, collection: true
    attribute :root_attr3, Shale::Type::String
    attribute :root_collection, Shale::Type::String, collection: true
    attribute :root_attr_complex, ComplexType

    hash do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_attr_complex', to: :root_attr_complex
    end

    json do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_attr_complex', to: :root_attr_complex
    end

    yaml do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_attr_complex', to: :root_attr_complex
    end

    xml do
      root 'root_type'
      map_attribute 'attr1', to: :root_attr1
      map_attribute 'collection', to: :root_collection
      map_element 'element1', to: :root_attr2
      map_element 'element2', to: :root_attr3
      map_element 'element_complex', to: :root_attr_complex
    end
  end
end

RSpec.describe Shale::Type::Complex do
  context 'with hash mapping' do
    let(:hash) do
      {
        'root_attr1' => 'foo',
        'root_attr2' => %w[one two three],
        'root_attr3' => nil,
        'root_attr_complex' => { 'complex_attr1' => 'bar' },
      }
    end

    describe '.from_hash' do
      it 'maps hash to object' do
        instance = ShaleComplexTesting::RootType.from_hash(hash)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
      end
    end

    describe '.to_hash' do
      it 'converts objects to hash' do
        instance = ShaleComplexTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar')
        )

        expect(instance.to_hash).to eq(hash)
      end
    end
  end

  context 'with json mapping' do
    let(:json) do
      <<~JSON.gsub(/\s+/, '')
        {
          "root_attr1": "foo",
          "root_attr2": ["one", "two", "three"],
          "root_attr3": null,
          "root_attr_complex": { "complex_attr1": "bar" }
        }
      JSON
    end

    describe '.from_json' do
      it 'maps json to object' do
        instance = ShaleComplexTesting::RootType.from_json(json)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
      end
    end

    describe '.to_json' do
      it 'converts objects to json' do
        instance = ShaleComplexTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar')
        )

        expect(instance.to_json).to eq(json)
      end
    end
  end

  context 'with yaml mapping' do
    # rubocop:disable Layout/TrailingWhitespace
    let(:yaml) do
      <<~YAML
        ---
        root_attr1: foo
        root_attr2:
        - one
        - two
        - three
        root_attr3: 
        root_attr_complex:
          complex_attr1: bar
      YAML
    end
    # rubocop:enable Layout/TrailingWhitespace

    describe '.from_yaml' do
      it 'maps yaml to object' do
        instance = ShaleComplexTesting::RootType.from_yaml(yaml)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
      end
    end

    describe '.to_yaml' do
      it 'converts objects to yaml' do
        instance = ShaleComplexTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar')
        )

        expect(instance.to_yaml).to eq(yaml)
      end
    end
  end

  context 'with xml mapping' do
    let(:xml) do
      <<~XML.gsub(/>\s+/, '>')
        <root_type attr1='foo' collection='[&quot;collection&quot;]'>
          <element1>one</element1>
          <element1>two</element1>
          <element1>three</element1>
          <element_complex>bar</element_complex>
        </root_type>
      XML
    end

    describe '.from_xml' do
      it 'maps xml to object' do
        instance = ShaleComplexTesting::RootType.from_xml(xml)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
      end
    end

    describe '.to_xml' do
      it 'converts objects to xml' do
        instance = ShaleComplexTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_collection: ['collection'],
          root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar')
        )

        expect(instance.to_xml).to eq(xml)
      end
    end
  end
end
