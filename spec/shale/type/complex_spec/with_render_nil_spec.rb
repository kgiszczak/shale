# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__RenderNil # rubocop:disable Naming/ClassAndModuleCamelCase
  class RenderNilDict < Shale::Mapper
    attribute :attr_true, Shale::Type::String
    attribute :attr_false, Shale::Type::String

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

    csv do
      map 'attr_true', to: :attr_true, render_nil: true
      map 'attr_false', to: :attr_false, render_nil: false
    end
  end

  class RenderNilXml < Shale::Mapper
    attribute :attr_true, Shale::Type::String
    attribute :attr_false, Shale::Type::String
    attribute :element_true, Shale::Type::String
    attribute :element_false, Shale::Type::String

    attribute :ns_attr_true, Shale::Type::String
    attribute :ns_attr_false, Shale::Type::String
    attribute :ns_element_true, Shale::Type::String
    attribute :ns_element_false, Shale::Type::String

    xml do
      root 'render_nil'

      map_attribute 'attr_true', to: :attr_true, render_nil: true
      map_attribute 'attr_false', to: :attr_false, render_nil: false
      map_element 'element_true', to: :element_true, render_nil: true
      map_element 'element_false', to: :element_false, render_nil: false

      map_attribute 'ns_attr_true',
        to: :ns_attr_true, namespace: 'http://ns1', prefix: 'ns1', render_nil: true

      map_attribute 'ns_attr_false',
        to: :ns_attr_false, namespace: 'http://ns2', prefix: 'ns2', render_nil: false

      map_element 'ns_element_true',
        to: :ns_element_true, namespace: 'http://ns3', prefix: 'ns3', render_nil: true

      map_element 'ns_element_false',
        to: :ns_element_false, namespace: 'http://ns4', prefix: 'ns4', render_nil: false
    end
  end
end

RSpec.describe Shale::Type::Complex do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
    Shale.yaml_adapter = YAML
    Shale.toml_adapter = Tomlib
    Shale.csv_adapter = Shale::Adapter::CSV
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  let(:mapper) { ComplexSpec__RenderNil::RenderNilDict }

  context 'with render_nil' do
    describe '.to_hash' do
      it 'converts objects to hash' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        expect(instance1.to_hash).to eq({ 'attr_true' => nil })
        expect(instance2.to_hash).to eq({ 'attr_true' => 'foo', 'attr_false' => 'bar' })
      end

      it 'converts collection to hash' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        expect(mapper.to_hash([instance1, instance2])).to eq([
          { 'attr_true' => nil },
          { 'attr_true' => 'foo', 'attr_false' => 'bar' },
        ])
      end
    end

    describe '.to_json' do
      it 'converts objects to JSON' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        expect(instance1.to_json).to eq('{"attr_true":null}')
        expect(instance2.to_json).to eq('{"attr_true":"foo","attr_false":"bar"}')
      end

      it 'converts collection to JSON' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        result = mapper.to_json([instance1, instance2])
        expect(result).to eq('[{"attr_true":null},{"attr_true":"foo","attr_false":"bar"}]')
      end
    end

    describe '.to_yaml' do
      it 'converts objects to YAML' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        expect(instance1.to_yaml.gsub(/ +$/, '')).to eq("---\nattr_true:\n")
        expect(instance2.to_yaml).to eq("---\nattr_true: foo\nattr_false: bar\n")
      end

      it 'converts collection to YAML' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        result = mapper.to_yaml([instance1, instance2]).gsub(/ +$/, '')
        expect(result).to eq("---\n- attr_true:\n- attr_true: foo\n  attr_false: bar\n")
      end
    end

    describe '.to_toml' do
      it 'converts objects to TOML' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        expect(instance1.to_toml).to eq("attr_true = \"\"\n")
        expect(instance2.to_toml).to eq("attr_true = \"foo\"\nattr_false = \"bar\"\n")
      end
    end

    describe '.to_csv' do
      it 'converts objects to CSV' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        expect(instance1.to_csv).to eq("\n")
        expect(instance2.to_csv).to eq("foo,bar\n")
      end

      it 'converts collection to CSV' do
        instance1 = mapper.new(attr_true: nil, attr_false: nil)
        instance2 = mapper.new(attr_true: 'foo', attr_false: 'bar')

        expect(mapper.to_csv([instance1, instance2])).to eq("\nfoo,bar\n")
      end
    end

    describe '.to_xml' do
      let(:mapper) { ComplexSpec__RenderNil::RenderNilXml }

      let(:expected_nil) do
        <<~XML.gsub(/>\s+/, '>').gsub(/"\s+/, '" ')
          <render_nil attr_true=""
            xmlns:ns1="http://ns1"
            xmlns:ns3="http://ns3"
            ns1:ns_attr_true="">
            <element_true/>
            <ns3:ns_element_true/>
          </render_nil>
        XML
      end

      let(:expected_set) do
        <<~XML.gsub(/>\s+/, '>').gsub(/"\s+/, '" ')
          <render_nil attr_false="bar"
            attr_true="foo"
            xmlns:ns1="http://ns1"
            xmlns:ns2="http://ns2"
            xmlns:ns3="http://ns3"
            xmlns:ns4="http://ns4"
            ns2:ns_attr_false="led"
            ns1:ns_attr_true="zed">
            <element_true>baz</element_true>
            <element_false>nab</element_false>
            <ns3:ns_element_true>ked</ns3:ns_element_true>
            <ns4:ns_element_false>mot</ns4:ns_element_false>
          </render_nil>
        XML
      end

      it 'converts objects to XML' do
        instance1 = mapper.new(
          attr_true: nil,
          attr_false: nil,
          element_true: nil,
          element_false: nil,

          ns_attr_true: nil,
          ns_attr_false: nil,
          ns_element_true: nil,
          ns_element_false: nil
        )
        instance2 = mapper.new(
          attr_true: 'foo',
          attr_false: 'bar',
          element_true: 'baz',
          element_false: 'nab',

          ns_attr_true: 'zed',
          ns_attr_false: 'led',
          ns_element_true: 'ked',
          ns_element_false: 'mot'
        )

        expect(instance1.to_xml).to eq(expected_nil)
        expect(instance2.to_xml).to eq(expected_set)
      end
    end
  end
end
