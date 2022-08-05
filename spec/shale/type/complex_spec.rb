# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'tomlib'

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

    def root_attr_using_from_hash(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_hash(model)
      model.root_attr_using
    end

    def root_attr_using_from_json(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_json(model)
      model.root_attr_using
    end

    def root_attr_using_from_yaml(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_yaml(model)
      model.root_attr_using
    end

    def root_attr_using_from_toml(model, value)
      model.root_attr_using = value
    end

    def root_attr_using_to_toml(model)
      model.root_attr_using
    end

    def root_attr_attribute_using_from_xml(model, value)
      model.root_attr_attribute_using = value
    end

    def root_attr_attribute_using_to_xml(model, element, doc)
      doc.add_attribute(element, 'attribute_using', model.root_attr_attribute_using)
    end

    def root_attr_using_from_xml(model, node)
      model.root_attr_using = node.text
    end

    def root_attr_using_to_xml(model, parent, doc)
      element = doc.create_element('element_using')
      doc.add_text(element, model.root_attr_using)
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

    def content_from_xml(model, element)
      model.content = element.text.gsub(',', '|')
    end

    def content_to_xml(model, element, doc)
      doc.add_text(element, model.content.gsub('|', ','))
    end
  end

  class RenderNil < Shale::Mapper
    attribute :attr_true, Shale::Type::String
    attribute :attr_false, Shale::Type::String
    attribute :xml_attr_true, Shale::Type::String
    attribute :xml_attr_false, Shale::Type::String

    attribute :ns_attr_true, Shale::Type::String
    attribute :ns_attr_false, Shale::Type::String
    attribute :ns_xml_attr_true, Shale::Type::String
    attribute :ns_xml_attr_false, Shale::Type::String

    hsh do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    json do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    yaml do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    toml do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end

    xml do
      root 'render_nil'

      map_attribute 'xml_attr_true', to: :xml_attr_true, render_nil: true
      map_attribute 'xml_attr_false', to: :xml_attr_false, render_nil: false
      map_element 'attr_true', to: :attr_true, render_nil: true
      map_element 'attr_false', to: :attr_false, render_nil: false

      map_attribute 'ns_xml_attr_true',
        to: :ns_xml_attr_true, namespace: 'http://ns1', prefix: 'ns1', render_nil: true
      map_attribute 'ns_xml_attr_false',
        to: :ns_xml_attr_false, namespace: 'http://ns2', prefix: 'ns2', render_nil: false
      map_element 'ns_attr_true',
        to: :ns_attr_true, namespace: 'http://ns3', prefix: 'ns3', render_nil: true
      map_element 'ns_attr_false',
        to: :ns_attr_false, namespace: 'http://ns4', prefix: 'ns4', render_nil: false
    end
  end

  class ComplexTypeModel
    attr_accessor :complex_attr1

    def initialize(complex_attr1: nil)
      @complex_attr1 = complex_attr1
    end
  end

  class ElementNamespacedModel
    attr_accessor :attr1, :ns1_attr1, :ns2_attr1,
      :not_namespaced, :ns1_one, :ns2_one

    def initialize(
      attr1: nil, ns1_attr1: nil, ns2_attr1: nil,
      not_namespaced: nil, ns1_one: nil, ns2_one: nil
    )
      @attr1 = attr1
      @ns1_attr1 = ns1_attr1
      @ns2_attr1 = ns2_attr1
      @not_namespaced = not_namespaced
      @ns1_one = ns1_one
      @ns2_one = ns2_one
    end
  end

  class RootTypeModel
    attr_accessor :root_attr1, :root_attr2, :root_attr3,
      :root_bool, :root_collection, :root_attr_complex,
      :root_attr_using, :root_attr_attribute_using, :element_namespaced

    def initialize(
      root_attr1: nil, root_attr2: nil, root_attr3: nil,
      root_bool: nil, root_collection: nil, root_attr_complex: nil,
      root_attr_using: nil, root_attr_attribute_using: nil, element_namespaced: nil
    )
      @root_attr1 = root_attr1
      @root_attr2 = root_attr2
      @root_attr3 = root_attr3
      @root_bool = root_bool
      @root_collection = root_collection
      @root_attr_complex = root_attr_complex
      @root_attr_using = root_attr_using
      @root_attr_attribute_using = root_attr_attribute_using
      @element_namespaced = element_namespaced
    end
  end
end

RSpec.describe Shale::Type::Complex do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
    Shale.yaml_adapter = YAML
    Shale.toml_adapter = Tomlib
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  context 'with no custom models' do
    before(:each) do
      ShaleComplexTesting::RootType.model(ShaleComplexTesting::RootType)
      ShaleComplexTesting::ComplexType.model(ShaleComplexTesting::ComplexType)
      ShaleComplexTesting::ElementNamespaced.model(ShaleComplexTesting::ElementNamespaced)
    end

    context 'with hash mapping' do
      let(:hash) do
        {
          'root_attr1' => 'foo',
          'root_attr2' => %w[one two three],
          'root_bool' => false,
          'root_attr_complex' => { 'complex_attr1' => 'bar' },
          'root_attr_using' => 'using_foo',
        }
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = ShaleComplexTesting::RootType.from_hash(hash)

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
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

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
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
          root_bool: false
          root_attr_complex:
            complex_attr1: bar
          root_attr_using: using_foo
        YAML
      end

      describe '.from_yaml' do
        it 'maps yaml to object' do
          instance = ShaleComplexTesting::RootType.from_yaml(yaml)

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
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
          root_attr2 = [ "one", "two", "three" ]
          root_bool = false
          root_attr_using = "using_foo"

          [root_attr_complex]
          complex_attr1 = "bar"
        TOML
      end

      describe '.from_toml' do
        it 'maps toml to object' do
          instance = ShaleComplexTesting::RootType.from_toml(from_toml)

          expect(instance.class).to eq(ShaleComplexTesting::RootType)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end
      end

      describe '.to_toml' do
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

            expect(instance.class).to eq(ShaleComplexTesting::RootType)
            expect(instance.root_attr1).to eq('foo')
            expect(instance.root_attr2).to eq(%w[one two three])
            expect(instance.root_attr3).to eq(nil)
            expect(instance.root_bool).to eq(false)
            expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexType)
            expect(instance.root_attr_complex.complex_attr1).to eq('bar')
            expect(instance.root_attr_using).to eq('foo_element_using')
            expect(instance.root_attr_attribute_using).to eq('foo')
            expect(instance.element_namespaced.class).to eq(ShaleComplexTesting::ElementNamespaced)
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
            expected = '<root_type attr1="" attribute_using="" collection="[]">' +
              '<element_using/></root_type>'
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

  context 'with custom models' do
    before(:each) do
      ShaleComplexTesting::RootType.model(ShaleComplexTesting::RootTypeModel)
      ShaleComplexTesting::ComplexType.model(ShaleComplexTesting::ComplexTypeModel)
      ShaleComplexTesting::ElementNamespaced.model(ShaleComplexTesting::ElementNamespacedModel)
    end

    context 'with hash mapping' do
      let(:hash) do
        {
          'root_attr1' => 'foo',
          'root_attr2' => %w[one two three],
          'root_bool' => false,
          'root_attr_complex' => { 'complex_attr1' => 'bar' },
          'root_attr_using' => 'using_foo',
        }
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = ShaleComplexTesting::RootType.from_hash(hash)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end
      end

      describe '.to_hash' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_hash('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to hash' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            expect(ShaleComplexTesting::RootType.to_hash(instance)).to eq(hash)
          end
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

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end
      end

      describe '.to_json' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_json('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to json' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            result = ShaleComplexTesting::RootType.to_json(instance)
            expect(result).to eq(json.gsub(/\s+/, ''))
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
          root_bool: false
          root_attr_complex:
            complex_attr1: bar
          root_attr_using: using_foo
        YAML
      end

      describe '.from_yaml' do
        it 'maps yaml to object' do
          instance = ShaleComplexTesting::RootType.from_yaml(yaml)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end
      end

      describe '.to_yaml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_yaml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to yaml' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            result = ShaleComplexTesting::RootType.to_yaml(instance)
            expect(result.gsub(/ +$/, '')).to eq(yaml)
          end
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
          root_attr2 = [ "one", "two", "three" ]
          root_bool = false
          root_attr_using = "using_foo"

          [root_attr_complex]
          complex_attr1 = "bar"
        TOML
      end

      describe '.from_toml' do
        it 'maps toml to object' do
          instance = ShaleComplexTesting::RootType.from_toml(from_toml)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('using_foo')
        end
      end

      describe '.to_toml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_toml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to toml' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'using_foo'
            )

            expect(ShaleComplexTesting::RootType.to_toml(instance)).to eq(to_toml)
          end
        end
      end
    end

    context 'with xml mapping' do
      let(:xml) do
        <<~XML
          <root_type_model attr1="foo"
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
          </root_type_model>
        XML
      end

      describe '.from_xml' do
        it 'maps xml to object' do
          instance = ShaleComplexTesting::RootType.from_xml(xml)

          expect(instance.class).to eq(ShaleComplexTesting::RootTypeModel)
          expect(instance.root_attr1).to eq('foo')
          expect(instance.root_attr2).to eq(%w[one two three])
          expect(instance.root_attr3).to eq(nil)
          expect(instance.root_bool).to eq(false)
          expect(instance.root_attr_complex.class).to eq(ShaleComplexTesting::ComplexTypeModel)
          expect(instance.root_attr_complex.complex_attr1).to eq('bar')
          expect(instance.root_attr_using).to eq('foo_element_using')
          expect(instance.root_attr_attribute_using).to eq('foo')
          expect(instance.element_namespaced.class).to(
            eq(ShaleComplexTesting::ElementNamespacedModel)
          )
          expect(instance.element_namespaced.attr1).to eq('attr1')
          expect(instance.element_namespaced.ns1_attr1).to eq('ns1 attr1')
          expect(instance.element_namespaced.ns2_attr1).to eq('ns2 attr1')
          expect(instance.element_namespaced.not_namespaced).to eq('not namespaced')
          expect(instance.element_namespaced.ns1_one).to eq('ns1 element one')
          expect(instance.element_namespaced.ns2_one).to eq('ns2 element one')
        end
      end

      describe '.to_xml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a 'ShaleComplexTesting::RootTypeModel/

            expect do
              ShaleComplexTesting::RootType.to_xml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to xml' do
            instance = ShaleComplexTesting::RootTypeModel.new(
              root_attr1: 'foo',
              root_attr2: %w[one two three],
              root_attr3: nil,
              root_collection: ['collection'],
              root_bool: false,
              root_attr_complex: ShaleComplexTesting::ComplexTypeModel.new(complex_attr1: 'bar'),
              root_attr_using: 'foo_element_using',
              root_attr_attribute_using: 'foo',
              element_namespaced: ShaleComplexTesting::ElementNamespacedModel.new(
                attr1: 'attr1',
                ns1_attr1: 'ns1 attr1',
                ns2_attr1: 'ns2 attr1',
                not_namespaced: 'not namespaced',
                ns1_one: 'ns1 element one',
                ns2_one: 'ns2 element one'
              )
            )

            result = ShaleComplexTesting::RootType.to_xml(instance)
            expect(result).to eq(xml.gsub(/>\s+/, '>').gsub(/"\s+/, '" '))
          end
        end
      end
    end
  end

  context 'with render_nil' do
    describe '.to_hash' do
      let(:expected_nil) do
        {
          'attr_true' => nil,
        }
      end

      let(:expected_set) do
        {
          'attr_true' => 'foo',
          'attr_false' => 'bar',
        }
      end

      it 'converts objects to hash' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil,
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar',
        )

        expect(instance1.to_hash).to eq(expected_nil)
        expect(instance2.to_hash).to eq(expected_set)
      end
    end

    describe '.to_json' do
      let(:expected_nil) do
        <<~JSON.sub(/\n\z/, '')
          {
            "attr_true": null
          }
        JSON
      end

      let(:expected_set) do
        <<~JSON.sub(/\n\z/, '')
          {
            "attr_true": "foo",
            "attr_false": "bar"
          }
        JSON
      end

      it 'converts objects to JSON' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil,
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar',
        )

        expect(instance1.to_json(:pretty)).to eq(expected_nil)
        expect(instance2.to_json(:pretty)).to eq(expected_set)
      end
    end

    describe '.to_yaml' do
      let(:expected_nil) do
        <<~YAML
          ---
          attr_true:
        YAML
      end

      let(:expected_set) do
        <<~YAML
          ---
          attr_true: foo
          attr_false: bar
        YAML
      end

      it 'converts objects to YAML' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil,
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar',
        )

        expect(instance1.to_yaml).to eq(expected_nil)
        expect(instance2.to_yaml).to eq(expected_set)
      end
    end

    describe '.to_toml' do
      let(:expected_nil) do
        <<~TOML
          attr_true = ""
        TOML
      end

      let(:expected_set) do
        <<~TOML
          attr_true = "foo"
          attr_false = "bar"
        TOML
      end

      it 'converts objects to TOML' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil,
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar',
        )

        expect(instance1.to_toml).to eq(expected_nil)
        expect(instance2.to_toml).to eq(expected_set)
      end
    end

    describe '.to_xml' do
      let(:expected_nil) do
        <<~XML.gsub(/>\s+/, '>').gsub(/"\s+/, '" ')
          <render_nil xmlns:ns1="http://ns1"
            xmlns:ns3="http://ns3"
            ns1:ns_xml_attr_true=""
            xml_attr_true="">
            <attr_true/>
            <ns3:ns_attr_true/>
          </render_nil>
        XML
      end

      let(:expected_set) do
        <<~XML.gsub(/>\s+/, '>').gsub(/"\s+/, '" ')
          <render_nil xmlns:ns1="http://ns1"
            xmlns:ns2="http://ns2"
            xmlns:ns3="http://ns3"
            xmlns:ns4="http://ns4"
            ns2:ns_xml_attr_false="mot"
            ns1:ns_xml_attr_true="ked"
            xml_attr_false="nab"
            xml_attr_true="baz">
            <attr_true>foo</attr_true>
            <attr_false>bar</attr_false>
            <ns3:ns_attr_true>zed</ns3:ns_attr_true>
            <ns4:ns_attr_false>led</ns4:ns_attr_false>
          </render_nil>
        XML
      end

      it 'converts objects to XML' do
        instance1 = ShaleComplexTesting::RenderNil.new(
          attr_true: nil,
          attr_false: nil,
          xml_attr_true: nil,
          xml_attr_false: nil,

          ns_attr_true: nil,
          ns_attr_false: nil,
          ns_xml_attr_true: nil,
          ns_xml_attr_false: nil,
        )
        instance2 = ShaleComplexTesting::RenderNil.new(
          attr_true: 'foo',
          attr_false: 'bar',
          xml_attr_true: 'baz',
          xml_attr_false: 'nab',

          ns_attr_true: 'zed',
          ns_attr_false: 'led',
          ns_xml_attr_true: 'ked',
          ns_xml_attr_false: 'mot',
        )

        expect(instance1.to_xml).to eq(expected_nil)
        expect(instance2.to_xml).to eq(expected_set)
      end
    end
  end
end
