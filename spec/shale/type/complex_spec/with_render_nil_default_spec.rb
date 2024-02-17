# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__RenderNilDefault # rubocop:disable Naming/ClassAndModuleCamelCase
  class DictBase < Shale::Mapper
    attribute :base, Shale::Type::String

    hsh do
      render_nil true
      map 'base', to: :base
    end

    json do
      render_nil true
      map 'base', to: :base
    end

    yaml do
      render_nil true
      map 'base', to: :base
    end

    toml do
      render_nil true
      map 'base', to: :base
    end

    csv do
      render_nil false
      map 'base', to: :base
    end
  end

  class DictDefault < DictBase
    attribute :foo, Shale::Type::String
    attribute :bar, Shale::Type::String

    hsh do
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    json do
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    yaml do
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    toml do
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    csv do
      map 'foo', to: :foo
      map 'bar', to: :bar
    end
  end

  class DictDefaultOverride < DictBase
    attribute :foo, Shale::Type::String
    attribute :bar, Shale::Type::String

    hsh do
      render_nil false
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    json do
      render_nil false
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    yaml do
      render_nil false
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    toml do
      render_nil false
      map 'foo', to: :foo
      map 'bar', to: :bar
    end

    csv do
      render_nil true
      map 'foo', to: :foo
      map 'bar', to: :bar
    end
  end

  class DictLocalOverride < DictBase
    attribute :foo, Shale::Type::String
    attribute :bar, Shale::Type::String

    hsh do
      map 'foo', to: :foo
      map 'bar', to: :bar, render_nil: false
    end

    json do
      map 'foo', to: :foo
      map 'bar', to: :bar, render_nil: false
    end

    yaml do
      map 'foo', to: :foo
      map 'bar', to: :bar, render_nil: false
    end

    toml do
      map 'foo', to: :foo
      map 'bar', to: :bar, render_nil: false
    end

    csv do
      map 'foo', to: :foo
      map 'bar', to: :bar, render_nil: true
    end
  end

  class XmlBase < Shale::Mapper
    attribute :base_element, Shale::Type::String
    attribute :base_attribute, Shale::Type::String

    xml do
      render_nil true

      map_element 'base', to: :base
      map_attribute 'base', to: :base
    end
  end

  class XmlDefault < XmlBase
    attribute :foo_element, Shale::Type::String
    attribute :bar_element, Shale::Type::String
    attribute :foo_attribute, Shale::Type::String
    attribute :bar_attribute, Shale::Type::String

    xml do
      root 'xml_default'

      map_element 'foo_element', to: :foo_element
      map_element 'bar_element', to: :bar_element
      map_attribute 'foo_attribute', to: :foo_attribute
      map_attribute 'bar_attribute', to: :bar_attribute
    end
  end

  class XmlDefaultOverride < XmlBase
    attribute :foo_element, Shale::Type::String
    attribute :bar_element, Shale::Type::String
    attribute :foo_attribute, Shale::Type::String
    attribute :bar_attribute, Shale::Type::String

    xml do
      root 'xml_default_override'

      render_nil false

      map_element 'foo_element', to: :foo_element
      map_element 'bar_element', to: :bar_element
      map_attribute 'foo_attribute', to: :foo_attribute
      map_attribute 'bar_attribute', to: :bar_attribute
    end
  end

  class XmlLocalOverride < XmlBase
    attribute :foo_element, Shale::Type::String
    attribute :bar_element, Shale::Type::String
    attribute :foo_attribute, Shale::Type::String
    attribute :bar_attribute, Shale::Type::String

    xml do
      root 'xml_local_override'

      map_element 'foo_element', to: :foo_element
      map_element 'bar_element', to: :bar_element, render_nil: false
      map_attribute 'foo_attribute', to: :foo_attribute
      map_attribute 'bar_attribute', to: :bar_attribute, render_nil: false
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

  context 'with render_nil default' do
    let(:mapper) { ComplexSpec__RenderNilDefault::DictDefault }

    describe '.to_hash' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_hash).to eq({ 'base' => nil, 'foo' => 'foo', 'bar' => nil })
      end
    end

    describe '.to_json' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_json).to eq('{"base":null,"foo":"foo","bar":null}')
      end
    end

    describe '.to_yaml' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_yaml.gsub(/ +$/, '')).to eq("---\nbase:\nfoo: foo\nbar:\n")
      end
    end

    describe '.to_toml' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_toml).to eq("base = \"\"\nfoo = \"foo\"\nbar = \"\"\n")
      end
    end

    describe '.to_csv' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_csv).to eq("foo\n")
      end
    end

    describe '.to_xml' do
      let(:mapper) { ComplexSpec__RenderNilDefault::XmlDefault }

      it 'converts objects to format' do
        instance = mapper.new(foo_element: 'foo', foo_attribute: 'foo')
        expect(instance.to_xml(pretty: true)).to eq(<<~DOC.gsub(/\n$/, ''))
          <xml_default foo_attribute="foo" bar_attribute="">
            <foo_element>foo</foo_element>
            <bar_element/>
          </xml_default>
        DOC
      end
    end
  end

  context 'with render_nil default override' do
    let(:mapper) { ComplexSpec__RenderNilDefault::DictDefaultOverride }

    describe '.to_hash' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_hash).to eq({ 'base' => nil, 'foo' => 'foo' })
      end
    end

    describe '.to_json' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_json).to eq('{"base":null,"foo":"foo"}')
      end
    end

    describe '.to_yaml' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_yaml.gsub(/ +$/, '')).to eq("---\nbase:\nfoo: foo\n")
      end
    end

    describe '.to_toml' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_toml).to eq("base = \"\"\nfoo = \"foo\"\n")
      end
    end

    describe '.to_csv' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_csv).to eq("foo,\n")
      end
    end

    describe '.to_xml' do
      let(:mapper) { ComplexSpec__RenderNilDefault::XmlDefaultOverride }

      it 'converts objects to format' do
        instance = mapper.new(foo_element: 'foo', foo_attribute: 'foo')
        expect(instance.to_xml(pretty: true)).to eq(<<~DOC.gsub(/\n$/, ''))
          <xml_default_override foo_attribute="foo">
            <foo_element>foo</foo_element>
          </xml_default_override>
        DOC
      end
    end
  end

  context 'with render_nil local override' do
    let(:mapper) { ComplexSpec__RenderNilDefault::DictLocalOverride }

    describe '.to_hash' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_hash).to eq({ 'base' => nil, 'foo' => 'foo' })
      end
    end

    describe '.to_json' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_json).to eq('{"base":null,"foo":"foo"}')
      end
    end

    describe '.to_yaml' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_yaml.gsub(/ +$/, '')).to eq("---\nbase:\nfoo: foo\n")
      end
    end

    describe '.to_toml' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_toml).to eq("base = \"\"\nfoo = \"foo\"\n")
      end
    end

    describe '.to_csv' do
      it 'converts objects to format' do
        instance = mapper.new(foo: 'foo')
        expect(instance.to_csv).to eq("foo,\n")
      end
    end

    describe '.to_xml' do
      let(:mapper) { ComplexSpec__RenderNilDefault::XmlLocalOverride }

      it 'converts objects to format' do
        instance = mapper.new(foo_element: 'foo', foo_attribute: 'foo')
        expect(instance.to_xml(pretty: true)).to eq(<<~DOC.gsub(/\n$/, ''))
          <xml_local_override foo_attribute="foo">
            <foo_element>foo</foo_element>
          </xml_local_override>
        DOC
      end
    end
  end
end
