# frozen_string_literal: true

require 'shale'

module ShaleCompositeTesting
  class CompositeType < Shale::Mapper
    attribute :composite_attr1, Shale::Type::String

    hash do
      map 'composite_attr1', to: :composite_attr1
    end

    json do
      map 'composite_attr1', to: :composite_attr1
    end

    yaml do
      map 'composite_attr1', to: :composite_attr1
    end

    xml do
      root 'composite_type'
      map_content to: :composite_attr1
    end
  end

  class RootType < Shale::Mapper
    attribute :root_attr1, Shale::Type::String
    attribute :root_attr2, Shale::Type::String, collection: true
    attribute :root_attr3, Shale::Type::String
    attribute :root_bool, Shale::Type::Boolean
    attribute :root_collection, Shale::Type::String, collection: true
    attribute :root_attr_composite, CompositeType
    attribute :root_attr_using, Shale::Type::String
    attribute :root_attr_attribute_using, Shale::Type::String

    hash do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_composite', to: :root_attr_composite
      map 'root_attr_using', using: {
        from: :root_attr_using_from_hash,
        to: :root_attr_using_to_hash,
      }
    end

    json do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_composite', to: :root_attr_composite
      map 'root_attr_using', using: {
        from: :root_attr_using_from_json,
        to: :root_attr_using_to_json,
      }
    end

    yaml do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_composite', to: :root_attr_composite
      map 'root_attr_using', using: {
        from: :root_attr_using_from_yaml,
        to: :root_attr_using_to_yaml,
      }
    end

    xml do
      root 'root_type'
      map_attribute 'attr1', to: :root_attr1
      map_attribute 'collection', to: :root_collection
      map_attribute 'attribute_using', using: {
        from: :root_attr_attribute_using_from_xml,
        to: :root_attr_attribute_using_to_xml,
      }
      map_element 'element1', to: :root_attr2
      map_element 'element2', to: :root_attr3
      map_element 'element_bool', to: :root_bool
      map_element 'element_composite', to: :root_attr_composite
      map_element 'element_using', using: {
        from: :root_attr_using_from_xml,
        to: :root_attr_using_to_xml,
      }
    end

    def root_attr_using_from_hash(value)
      self.root_attr_using = value
    end

    def root_attr_using_to_hash
      root_attr_using
    end

    def root_attr_using_from_json(value)
      self.root_attr_using = value
    end

    def root_attr_using_to_json
      root_attr_using
    end

    def root_attr_using_from_yaml(value)
      self.root_attr_using = value
    end

    def root_attr_using_to_yaml
      root_attr_using
    end

    def root_attr_attribute_using_from_xml(value)
      self.root_attr_attribute_using = value
    end

    def root_attr_attribute_using_to_xml(element, doc)
      doc.add_attribute(element, 'attribute_using', root_attr_attribute_using)
    end

    def root_attr_using_from_xml(node)
      self.root_attr_using = node.text
    end

    def root_attr_using_to_xml(parent, doc)
      element = doc.create_element('element_using')
      doc.add_text(element, root_attr_using)
      doc.add_element(parent, element)
    end
  end
end

RSpec.describe Shale::Type::Composite do
  context 'with hash mapping' do
    let(:hash) do
      {
        'root_attr1' => 'foo',
        'root_attr2' => %w[one two three],
        'root_attr3' => nil,
        'root_bool' => false,
        'root_attr_composite' => { 'composite_attr1' => 'bar' },
        'root_attr_using' => 'using_foo',
      }
    end

    describe '.from_hash' do
      it 'maps hash to object' do
        instance = ShaleCompositeTesting::RootType.from_hash(hash)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_composite.composite_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('using_foo')
      end
    end

    describe '.to_hash' do
      it 'converts objects to hash' do
        instance = ShaleCompositeTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_bool: false,
          root_attr_composite: ShaleCompositeTesting::CompositeType.new(composite_attr1: 'bar'),
          root_attr_using: 'using_foo'
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
          "root_bool": false,
          "root_attr_composite": { "composite_attr1": "bar" },
          "root_attr_using": "using_foo"
        }
      JSON
    end

    describe '.from_json' do
      it 'maps json to object' do
        instance = ShaleCompositeTesting::RootType.from_json(json)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_composite.composite_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('using_foo')
      end
    end

    describe '.to_json' do
      it 'converts objects to json' do
        instance = ShaleCompositeTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_bool: false,
          root_attr_composite: ShaleCompositeTesting::CompositeType.new(composite_attr1: 'bar'),
          root_attr_using: 'using_foo'
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
        root_bool: false
        root_attr_composite:
          composite_attr1: bar
        root_attr_using: using_foo
      YAML
    end
    # rubocop:enable Layout/TrailingWhitespace

    describe '.from_yaml' do
      it 'maps yaml to object' do
        instance = ShaleCompositeTesting::RootType.from_yaml(yaml)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_composite.composite_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('using_foo')
      end
    end

    describe '.to_yaml' do
      it 'converts objects to yaml' do
        instance = ShaleCompositeTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_bool: false,
          root_attr_composite: ShaleCompositeTesting::CompositeType.new(composite_attr1: 'bar'),
          root_attr_using: 'using_foo'
        )

        expect(instance.to_yaml).to eq(yaml)
      end
    end
  end

  context 'with xml mapping' do
    let(:xml) do
      <<~XML.gsub(/>\s+/, '>')
        <root_type attr1='foo' attribute_using='foo' collection='[&quot;collection&quot;]'>
          <element1>one</element1>
          <element1>two</element1>
          <element1>three</element1>
          <element_bool>false</element_bool>
          <element_composite>bar</element_composite>
          <element_using>foo_element_using</element_using>
        </root_type>
      XML
    end

    describe '.from_xml' do
      it 'maps xml to object' do
        instance = ShaleCompositeTesting::RootType.from_xml(xml)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_composite.composite_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('foo_element_using')
        expect(instance.root_attr_attribute_using).to eq('foo')
      end
    end

    describe '.to_xml' do
      it 'converts objects to xml' do
        instance = ShaleCompositeTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_collection: ['collection'],
          root_bool: false,
          root_attr_composite: ShaleCompositeTesting::CompositeType.new(composite_attr1: 'bar'),
          root_attr_using: 'foo_element_using',
          root_attr_attribute_using: 'foo'
        )

        expect(instance.to_xml).to eq(xml)
      end

      it 'converts blank attributes to xml' do
        instance = ShaleCompositeTesting::RootType.new(root_attr1: '')
        expected = "<root_type attr1='' collection='[]'><element_using/></root_type>"
        expect(instance.to_xml).to eq(expected)
      end
    end
  end
end
