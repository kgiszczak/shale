# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/toml_rb'

module ShaleComplexTesting
  class ComplexType < Shale::Mapper
    attribute :complex_attr1, Shale::Type::String

    hsh do
      map 'complex_attr1', to: :complex_attr1
    end

    json do
      map 'complex_attr1', to: :complex_attr1
    end

    yaml do
      map 'complex_attr1', to: :complex_attr1
    end

    toml do
      map 'complex_attr1', to: :complex_attr1
    end

    xml do
      root 'complex_type'
      map_content to: :complex_attr1
    end
  end

  class ElementNamespaced < Shale::Mapper
    attribute :attr1, Shale::Type::String
    attribute :ns1_attr1, Shale::Type::String
    attribute :ns2_attr1, Shale::Type::String
    attribute :not_namespaced, Shale::Type::String
    attribute :ns1_one, Shale::Type::String
    attribute :ns2_one, Shale::Type::String

    xml do
      root 'element_namespaced'
      namespace 'http://ns1.com', 'ns1'

      map_attribute 'attr1', to: :attr1
      map_attribute 'attr1', to: :ns1_attr1, namespace: 'http://ns1.com', prefix: 'ns1'
      map_attribute 'attr1', to: :ns2_attr1, namespace: 'http://ns2.com', prefix: 'ns2'
      map_element 'not_namespaced', to: :not_namespaced, namespace: nil, prefix: nil
      map_element 'one', to: :ns1_one
      map_element 'one', to: :ns2_one, namespace: 'http://ns2.com', prefix: 'ns2'
    end
  end

  class RootType < Shale::Mapper
    attribute :root_attr1, Shale::Type::String
    attribute :root_attr2, Shale::Type::String, collection: true
    attribute :root_attr3, Shale::Type::String
    attribute :root_bool, Shale::Type::Boolean
    attribute :root_collection, Shale::Type::String, collection: true
    attribute :root_attr_complex, ComplexType
    attribute :root_attr_using, Shale::Type::String
    attribute :root_attr_attribute_using, Shale::Type::String
    attribute :element_namespaced, ElementNamespaced

    hsh do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_complex', to: :root_attr_complex
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
      map 'root_attr_complex', to: :root_attr_complex
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
      map 'root_attr_complex', to: :root_attr_complex
      map 'root_attr_using', using: {
        from: :root_attr_using_from_yaml,
        to: :root_attr_using_to_yaml,
      }
    end

    toml do
      map 'root_attr1', to: :root_attr1
      map 'root_attr2', to: :root_attr2
      map 'root_attr3', to: :root_attr3
      map 'root_bool', to: :root_bool
      map 'root_attr_complex', to: :root_attr_complex
      map 'root_attr_using', using: {
        from: :root_attr_using_from_toml,
        to: :root_attr_using_to_toml,
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
      map_element 'element_complex', to: :root_attr_complex
      map_element 'element_using', using: {
        from: :root_attr_using_from_xml,
        to: :root_attr_using_to_xml,
      }
      map_element 'element_namespaced',
        to: :element_namespaced,
        namespace: 'http://ns1.com',
        prefix: 'ns1'
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

    def root_attr_using_from_toml(value)
      self.root_attr_using = value
    end

    def root_attr_using_to_toml
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

  class CdataChild < Shale::Mapper
    attribute :element1, Shale::Type::String

    xml do
      map_content to: :element1, cdata: true
    end
  end

  class CdataParent < Shale::Mapper
    attribute :element1, Shale::Type::String
    attribute :element2, Shale::Type::String, collection: true
    attribute :cdata_child, CdataChild

    xml do
      root 'cdata_parent'

      map_element 'element1', to: :element1, cdata: true
      map_element 'element2', to: :element2, cdata: true
      map_element 'cdata_child', to: :cdata_child
    end
  end

  class ContentUsing < Shale::Mapper
    attribute :content, Shale::Type::String

    xml do
      root 'content_using'

      map_content using: { from: :content_from_xml, to: :content_to_xml }
    end

    def content_from_xml(element)
      self.content = element.text.gsub(',', '|')
    end

    def content_to_xml(element, doc)
      doc.add_text(element, self.content.gsub('|', ','))
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
        'root_bool' => false,
        'root_attr_complex' => { 'complex_attr1' => 'bar' },
        'root_attr_using' => 'using_foo',
      }
    end

    describe '.from_hash' do
      it 'maps hash to object' do
        instance = ShaleComplexTesting::RootType.from_hash(hash)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('using_foo')
      end
    end

    describe '.to_hash' do
      it 'converts objects to hash' do
        instance = ShaleComplexTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_bool: false,
          root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
          root_attr_using: 'using_foo'
        )

        expect(instance.to_hash).to eq(hash)
      end
    end
  end

  context 'with json mapping' do
    let(:json) do
      <<~JSON
        {
          "root_attr1": "foo",
          "root_attr2": [
            "one",
            "two",
            "three"
          ],
          "root_attr3": null,
          "root_bool": false,
          "root_attr_complex": {
            "complex_attr1": "bar"
          },
          "root_attr_using": "using_foo"
        }
      JSON
    end

    describe '.from_json' do
      it 'maps json to object' do
        instance = ShaleComplexTesting::RootType.from_json(json)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('using_foo')
      end
    end

    describe '.to_json' do
      context 'without params' do
        it 'converts objects to json' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'using_foo'
          )

          expect(instance.to_json).to eq(json.gsub(/\s+/, ''))
        end
      end

      context 'with :pretty param' do
        it 'converts objects to json and formats it' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'using_foo'
          )

          expect(instance.to_json(:pretty)).to eq(json.sub(/\n\z/, ''))
        end
      end
    end
  end

  context 'with yaml mapping' do
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
        root_attr_complex:
          complex_attr1: bar
        root_attr_using: using_foo
      YAML
    end

    describe '.from_yaml' do
      it 'maps yaml to object' do
        instance = ShaleComplexTesting::RootType.from_yaml(yaml)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('using_foo')
      end
    end

    describe '.to_yaml' do
      it 'converts objects to yaml' do
        instance = ShaleComplexTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_bool: false,
          root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
          root_attr_using: 'using_foo'
        )

        expect(instance.to_yaml.gsub(/ +$/, '')).to eq(yaml)
      end
    end
  end

  context 'with toml mapping' do
    let(:from_toml) do
      <<~TOML
        root_attr1 = "foo"
        root_attr2 = ["one", "two", "three"]
        root_bool = false
        root_attr_using = "using_foo"
        [root_attr_complex]
        complex_attr1 = "bar"
      TOML
    end

    let(:to_toml) do
      <<~TOML
        root_attr1 = "foo"
        root_attr2 = ["one", "two", "three"]
        root_attr3 = nil
        root_attr_using = "using_foo"
        root_bool = false
        [root_attr_complex]
        complex_attr1 = "bar"
      TOML
    end

    describe '.from_toml' do
      before(:each) do
        Shale.toml_adapter = Shale::Adapter::TomlRB
      end

      it 'maps toml to object' do
        instance = ShaleComplexTesting::RootType.from_toml(from_toml)

        expect(instance.root_attr1).to eq('foo')
        expect(instance.root_attr2).to eq(%w[one two three])
        expect(instance.root_attr3).to eq(nil)
        expect(instance.root_bool).to eq(false)
        expect(instance.root_attr_complex.complex_attr1).to eq('bar')
        expect(instance.root_attr_using).to eq('using_foo')
      end
    end

    describe '.to_toml' do
      before(:each) do
        Shale.toml_adapter = Shale::Adapter::TomlRB
      end

      it 'converts objects to toml' do
        instance = ShaleComplexTesting::RootType.new(
          root_attr1: 'foo',
          root_attr2: %w[one two three],
          root_attr3: nil,
          root_bool: false,
          root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
          root_attr_using: 'using_foo'
        )

        expect(instance.to_toml).to eq(to_toml)
      end
    end
  end

  context 'with xml mapping' do
    let(:xml) do
      <<~XML
        <root_type attr1="foo"
          attribute_using="foo"
          collection="[&quot;collection&quot;]"
          xmlns:ns1="http://ns1.com"
          xmlns:ns2="http://ns2.com">
          <element1>one</element1>
          <element1>two</element1>
          <element1>three</element1>
          <element_bool>false</element_bool>
          <element_complex>bar</element_complex>
          <element_using>foo_element_using</element_using>
          <ns1:element_namespaced attr1="attr1" ns1:attr1="ns1 attr1" ns2:attr1="ns2 attr1">
            <not_namespaced>not namespaced</not_namespaced>
            <ns1:one>ns1 element one</ns1:one>
            <ns2:one>ns2 element one</ns2:one>
          </ns1:element_namespaced>
        </root_type>
      XML
    end

    describe '.from_xml' do
      before(:each) do
        Shale.xml_adapter = Shale::Adapter::REXML
      end

      context 'when XML adapter is not set' do
        it 'raises an error' do
          Shale.xml_adapter = nil

          expect do
            ShaleComplexTesting::RootType.from_xml(xml)
          end.to raise_error(Shale::AdapterError, /XML Adapter is not set/)
        end
      end

      context 'when XML adapter is set' do
        it 'maps xml to object' do
          instance = ShaleComplexTesting::RootType.from_xml(xml)

          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('foo_element_using')
          expect(instance.root_attr_attribute_using).to eq('foo')
          expect(instance.element_namespaced.attr1).to eq('attr1')
          expect(instance.element_namespaced.ns1_attr1).to eq('ns1 attr1')
          expect(instance.element_namespaced.ns2_attr1).to eq('ns2 attr1')
          expect(instance.element_namespaced.not_namespaced).to eq('not namespaced')
          expect(instance.element_namespaced.ns1_one).to eq('ns1 element one')
          expect(instance.element_namespaced.ns2_one).to eq('ns2 element one')
        end
      end

      context 'with CDATA elements' do
        let(:xml) do
          <<~XML
            <cdata_type>
              <element1>foo</element1>
              <element2>one</element2>
              <element2>two</element2>
              <element2>three</element2>
              <cdata_child>child</cdata_child>
            </cdata_type>
          XML
        end

        it 'maps xml to object' do
          instance = ShaleComplexTesting::CdataParent.from_xml(xml)

          expect(instance.element1).to eq('foo')
          expect(instance.element2).to eq(%w[one two three])
          expect(instance.cdata_child.element1).to eq('child')
        end
      end

      context 'with content using methods' do
        let(:xml) do
          <<~XML
            <content_using>foo,bar,baz</content_using>
          XML
        end

        it 'maps xml to object' do
          instance = ShaleComplexTesting::ContentUsing.from_xml(xml)

          expect(instance.content).to eq('foo|bar|baz')
        end
      end
    end

    describe '.to_xml' do
      before(:each) do
        Shale.xml_adapter = Shale::Adapter::REXML
      end

      context 'when XML adapter is not set' do
        it 'raises an error' do
          Shale.xml_adapter = nil

          expect do
            ShaleComplexTesting::RootType.new.to_xml
          end.to raise_error(Shale::AdapterError, /XML Adapter is not set/)
        end
      end

      context 'without params' do
        it 'converts objects to xml' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_attr2: %w[one two three],
            root_attr3: nil,
            root_collection: ['collection'],
            root_bool: false,
            root_attr_complex: ShaleComplexTesting::ComplexType.new(complex_attr1: 'bar'),
            root_attr_using: 'foo_element_using',
            root_attr_attribute_using: 'foo',
            element_namespaced: ShaleComplexTesting::ElementNamespaced.new(
              attr1: 'attr1',
              ns1_attr1: 'ns1 attr1',
              ns2_attr1: 'ns2 attr1',
              not_namespaced: 'not namespaced',
              ns1_one: 'ns1 element one',
              ns2_one: 'ns2 element one'
            )
          )

          expect(instance.to_xml).to eq(xml.gsub(/>\s+/, '>').gsub(/"\s+/, '" '))
        end

        it 'converts blank attributes to xml' do
          instance = ShaleComplexTesting::RootType.new(root_attr1: '')
          expected = '<root_type attr1="" collection="[]"><element_using/></root_type>'
          expect(instance.to_xml).to eq(expected)
        end
      end

      context 'with :pretty param' do
        it 'converts objects to xml and formats it' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_bool: false,
            root_attr_using: 'foo_element_using',
            root_attr_attribute_using: 'foo'
          )

          xml = <<~XML.sub(/\n\z/, '')
            <root_type attr1="foo" collection="[]" attribute_using="foo">
              <element_bool>false</element_bool>
              <element_using>foo_element_using</element_using>
            </root_type>
          XML

          expect(instance.to_xml(:pretty)).to eq(xml)
        end
      end

      context 'with :declaration param' do
        it 'converts objects to xml with declaration' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_bool: false,
            root_attr_using: 'foo_element_using',
            root_attr_attribute_using: 'foo'
          )

          xml = <<~XML.gsub(/>\s+/, '>').gsub(/'\s+/, "' ")
            <?xml version="1.0"?>
            <root_type attr1="foo" attribute_using="foo" collection="[]">
              <element_bool>false</element_bool>
              <element_using>foo_element_using</element_using>
            </root_type>
          XML

          expect(instance.to_xml(:declaration)).to eq(xml)
        end
      end

      context 'with :pretty and :declaration param' do
        it 'converts objects to xml with declaration and formats it' do
          instance = ShaleComplexTesting::RootType.new(
            root_attr1: 'foo',
            root_bool: false,
            root_attr_using: 'foo_element_using',
            root_attr_attribute_using: 'foo'
          )

          xml = <<~XML.sub(/\n\z/, '')
            <?xml version="1.0"?>
            <root_type attr1="foo" collection="[]" attribute_using="foo">
              <element_bool>false</element_bool>
              <element_using>foo_element_using</element_using>
            </root_type>
          XML

          expect(instance.to_xml(:pretty, :declaration)).to eq(xml)
        end
      end

      context 'with CDATA elements' do
        it 'converts objects to xml' do
          instance = ShaleComplexTesting::CdataParent.new(
            element1: 'foo',
            element2: %w[one two three],
            cdata_child: ShaleComplexTesting::CdataChild.new(element1: 'child')
          )

          xml = <<~XML.sub(/\n\z/, '')
            <cdata_parent>
              <element1><![CDATA[foo]]></element1>
              <element2><![CDATA[one]]></element2>
              <element2><![CDATA[two]]></element2>
              <element2><![CDATA[three]]></element2>
              <cdata_child><![CDATA[child]]></cdata_child>
            </cdata_parent>
          XML

          expect(instance.to_xml(:pretty)).to eq(xml)
        end
      end

      context 'with content using methods' do
        it 'converts objects to xml' do
          instance = ShaleComplexTesting::ContentUsing.new(content: 'foo|bar|baz')

          xml = <<~XML.sub(/\n\z/, '')
            <content_using>foo,bar,baz</content_using>
          XML

          expect(instance.to_xml(:pretty)).to eq(xml)
        end
      end
    end
  end
end
