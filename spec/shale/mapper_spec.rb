# frozen_string_literal: true

require 'shale/mapper'
require 'shale/type/string'
require 'shale/type/integer'

module ShaleMapperTesting
  BAR_DEFAULT_PROC = -> { 'bar' }

  class Parent < Shale::Mapper
    attribute :foo, Shale::Type::String
    attribute :bar, Shale::Type::String, default: BAR_DEFAULT_PROC
    attribute :baz, Shale::Type::String, collection: true
    attribute :foo_int, Shale::Type::Integer
  end

  class Child1 < Parent
    attribute :child1_foo, Shale::Type::String

    # rubocop:disable Lint/EmptyBlock
    hsh do
    end

    json do
    end

    yaml do
    end

    toml do
    end

    xml do
    end
    # rubocop:enable Lint/EmptyBlock
  end

  class Child2 < Child1
    attribute :child2_foo, Shale::Type::String
  end

  class Child3 < Child2
    attribute :child3_foo, Shale::Type::String

    hsh do
      map 'child3_bar', to: :child3_foo
    end

    json do
      map 'child3_bar', to: :child3_foo
    end

    yaml do
      map 'child3_bar', to: :child3_foo
    end

    toml do
      map 'child3_bar', to: :child3_foo
    end

    xml do
      root 'child3-foo-bar'
      map_element 'child3_bar', to: :child3_foo
    end
  end

  class HashMapping < Shale::Mapper
    attribute :foo, Shale::Type::String

    hsh do
      map 'bar', to: :foo
    end
  end

  class JsonMapping < Shale::Mapper
    attribute :foo, Shale::Type::String

    json do
      map 'bar', to: :foo
    end
  end

  class YamlMapping < Shale::Mapper
    attribute :foo, Shale::Type::String

    yaml do
      map 'bar', to: :foo
    end
  end

  class TomlMapping < Shale::Mapper
    attribute :foo, Shale::Type::String

    toml do
      map 'bar', to: :foo
    end
  end

  class XmlMapping < Shale::Mapper
    attribute :foo_element, Shale::Type::String
    attribute :ns2_element, Shale::Type::String
    attribute :foo_attribute, Shale::Type::String
    attribute :foo_content, Shale::Type::String

    xml do
      root 'foobar'
      namespace 'http://ns1.com', 'ns1'
      map_element 'bar', to: :foo_element
      map_element 'ns2_bar', to: :ns2_element, namespace: 'http://ns2.com', prefix: 'ns2'
      map_attribute 'bar', to: :foo_attribute
      map_content to: :foo_content
    end
  end

  class MapperWithouModel < Shale::Mapper
  end

  # rubocop:disable Lint/EmptyClass
  class Model
  end
  # rubocop:enable Lint/EmptyClass

  class MapperWithModel < Shale::Mapper
    model Model
  end
end

RSpec.describe Shale::Mapper do
  describe '.inherited' do
    it 'copies attributes from parent' do
      mapping = ShaleMapperTesting::Parent.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int])

      mapping = ShaleMapperTesting::Child1.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int child1_foo])

      mapping = ShaleMapperTesting::Child2.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int child1_foo child2_foo])

      mapping = ShaleMapperTesting::Child3.attributes.keys
      expect(mapping).to eq(%i[foo bar baz foo_int child1_foo child2_foo child3_foo])
    end

    it 'copies hash_mapping from parent' do
      mapping = ShaleMapperTesting::Parent.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child1.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child2.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = ShaleMapperTesting::Child3.hash_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies json_mapping from parent' do
      mapping = ShaleMapperTesting::Parent.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child1.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child2.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = ShaleMapperTesting::Child3.json_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies yaml_mapping from parent' do
      mapping = ShaleMapperTesting::Parent.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child1.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child2.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = ShaleMapperTesting::Child3.yaml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies toml_mapping from parent' do
      mapping = ShaleMapperTesting::Parent.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child1.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)

      mapping = ShaleMapperTesting::Child2.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)

      mapping = ShaleMapperTesting::Child3.toml_mapping.keys
      expect(mapping.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping['foo'].attribute).to eq(:foo)
      expect(mapping['bar'].attribute).to eq(:bar)
      expect(mapping['baz'].attribute).to eq(:baz)
      expect(mapping['foo_int'].attribute).to eq(:foo_int)
      expect(mapping['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping['child3_bar'].attribute).to eq(:child3_foo)
    end

    it 'copies xml_mapping from parent' do
      mapping = ShaleMapperTesting::Parent.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('parent')

      mapping = ShaleMapperTesting::Child1.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('')

      mapping = ShaleMapperTesting::Child2.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int child2_foo])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.elements['child2_foo'].attribute).to eq(:child2_foo)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('child2')

      mapping = ShaleMapperTesting::Child3.xml_mapping
      expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int child2_foo child3_bar])
      expect(mapping.elements['foo'].attribute).to eq(:foo)
      expect(mapping.elements['bar'].attribute).to eq(:bar)
      expect(mapping.elements['baz'].attribute).to eq(:baz)
      expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)
      expect(mapping.elements['child3_bar'].attribute).to eq(:child3_foo)
      expect(mapping.attributes).to eq({})
      expect(mapping.content).to eq(nil)
      expect(mapping.prefixed_root).to eq('child3-foo-bar')
    end
  end

  describe '.model' do
    context 'when model is not set' do
      it 'returns Mapper class' do
        klass = ShaleMapperTesting::MapperWithouModel
        expect(klass.model).to eq(klass)
      end
    end

    context 'when model is set' do
      it 'returns model class' do
        klass = ShaleMapperTesting::MapperWithModel
        expect(klass.model).to eq(ShaleMapperTesting::Model)
      end

      it 'sets root on XML mapping' do
        mapping = ShaleMapperTesting::MapperWithModel.xml_mapping
        expect(mapping.unprefixed_root).to eq('model')
      end
    end
  end

  describe '.attribute' do
    context 'when default value is not callable' do
      it 'raises an error' do
        expect do
          # rubocop:disable Lint/ConstantDefinitionInBlock
          class FooBarBaz < described_class
            attribute :foo, Shale::Type::String, default: ''
          end
          # rubocop:enable Lint/ConstantDefinitionInBlock
        end.to raise_error(Shale::DefaultNotCallableError)
      end
    end

    context 'with correct attribute definitions' do
      it 'sets reader and writter with type casting' do
        subject = ShaleMapperTesting::Parent.new
        subject.foo_int = '123'
        expect(subject.foo_int).to eq(123)
      end

      it 'sets attributes' do
        attributes = ShaleMapperTesting::Parent.attributes
        expect(attributes.keys).to eq(%i[foo bar baz foo_int])

        expect(attributes[:foo].name).to eq(:foo)
        expect(attributes[:foo].type).to eq(Shale::Type::String)
        expect(attributes[:foo].collection?).to eq(false)
        expect(attributes[:foo].default).to eq(nil)

        expect(attributes[:bar].name).to eq(:bar)
        expect(attributes[:bar].type).to eq(Shale::Type::String)
        expect(attributes[:bar].collection?).to eq(false)
        expect(attributes[:bar].default).to eq(ShaleMapperTesting::BAR_DEFAULT_PROC)

        expect(attributes[:baz].name).to eq(:baz)
        expect(attributes[:baz].type).to eq(Shale::Type::String)
        expect(attributes[:baz].collection?).to eq(true)
        expect(attributes[:baz].default.call).to eq([])

        expect(attributes[:foo_int].name).to eq(:foo_int)
        expect(attributes[:foo_int].type).to eq(Shale::Type::Integer)
        expect(attributes[:foo_int].collection?).to eq(false)
        expect(attributes[:foo_int].default).to eq(nil)
      end

      it 'default hash mapping' do
        mapping = ShaleMapperTesting::Parent.hash_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default json mapping' do
        mapping = ShaleMapperTesting::Parent.json_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default yaml mapping' do
        mapping = ShaleMapperTesting::Parent.yaml_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default toml mapping' do
        mapping = ShaleMapperTesting::Parent.toml_mapping.keys
        expect(mapping.keys).to eq(%w[foo bar baz foo_int])
        expect(mapping['foo'].attribute).to eq(:foo)
        expect(mapping['bar'].attribute).to eq(:bar)
        expect(mapping['baz'].attribute).to eq(:baz)
        expect(mapping['foo_int'].attribute).to eq(:foo_int)
      end

      it 'default xml mapping' do
        mapping = ShaleMapperTesting::Parent.xml_mapping

        expect(mapping.elements.keys).to eq(%w[foo bar baz foo_int])

        expect(mapping.elements['foo'].attribute).to eq(:foo)
        expect(mapping.elements['bar'].attribute).to eq(:bar)
        expect(mapping.elements['baz'].attribute).to eq(:baz)
        expect(mapping.elements['foo_int'].attribute).to eq(:foo_int)

        expect(mapping.attributes).to eq({})
        expect(mapping.content).to eq(nil)
        expect(mapping.prefixed_root).to(eq('parent'))
      end
    end
  end

  describe '.hsh' do
    it 'declares custom Hash mapping' do
      expect(ShaleMapperTesting::HashMapping.hash_mapping.keys.keys).to eq(['bar'])
      expect(ShaleMapperTesting::HashMapping.hash_mapping.keys['bar'].attribute).to eq(:foo)
    end
  end

  describe '.json' do
    it 'declares custom JSON mapping' do
      expect(ShaleMapperTesting::JsonMapping.json_mapping.keys.keys).to eq(['bar'])
      expect(ShaleMapperTesting::JsonMapping.json_mapping.keys['bar'].attribute).to eq(:foo)
    end
  end

  describe '.yaml' do
    it 'declares custom YAML mapping' do
      expect(ShaleMapperTesting::YamlMapping.yaml_mapping.keys.keys).to eq(['bar'])
      expect(ShaleMapperTesting::YamlMapping.yaml_mapping.keys['bar'].attribute).to eq(:foo)
    end
  end

  describe '.toml' do
    it 'declares custom TOML mapping' do
      expect(ShaleMapperTesting::TomlMapping.toml_mapping.keys.keys).to eq(['bar'])
      expect(ShaleMapperTesting::TomlMapping.toml_mapping.keys['bar'].attribute).to eq(:foo)
    end
  end

  describe '.xml' do
    it 'declares custom XML mapping' do
      elements = ShaleMapperTesting::XmlMapping.xml_mapping.elements
      attributes = ShaleMapperTesting::XmlMapping.xml_mapping.attributes
      namespace = ShaleMapperTesting::XmlMapping.xml_mapping.default_namespace

      expect(elements.keys).to eq(%w[http://ns1.com:bar http://ns2.com:ns2_bar])
      expect(elements['http://ns1.com:bar'].attribute).to eq(:foo_element)
      expect(elements['http://ns2.com:ns2_bar'].attribute).to eq(:ns2_element)
      expect(attributes.keys).to eq(['bar'])
      expect(attributes['bar'].attribute).to eq(:foo_attribute)
      expect(ShaleMapperTesting::XmlMapping.xml_mapping.content.attribute).to eq(:foo_content)
      expect(ShaleMapperTesting::XmlMapping.xml_mapping.prefixed_root).to eq('ns1:foobar')
      expect(namespace.name).to eq('http://ns1.com')
      expect(namespace.prefix).to eq('ns1')
    end
  end

  describe '#initialize' do
    context 'when attribute does not exist' do
      it 'raises an error' do
        expect do
          ShaleMapperTesting::Parent.new(not_existing: 'foo bar')
        end.to(
          raise_error(Shale::UnknownAttributeError)
        )
      end
    end

    context 'with attribute' do
      it 'sets the attribute to nil' do
        subject = ShaleMapperTesting::Parent.new
        expect(subject.foo).to eq(nil)
      end
    end

    context 'without attribute and with default value' do
      it 'sets the attribute to default value' do
        subject = ShaleMapperTesting::Parent.new
        expect(subject.bar).to eq('bar')
      end
    end

    context 'with attribute and with default value' do
      it 'sets the attribute' do
        subject = ShaleMapperTesting::Parent.new(bar: 'baz')
        expect(subject.bar).to eq('baz')
      end
    end

    context 'when attribute exist' do
      it 'sets the attribute' do
        subject = ShaleMapperTesting::Parent.new(foo: 'foo')
        expect(subject.foo).to eq('foo')
      end
    end
  end
end
