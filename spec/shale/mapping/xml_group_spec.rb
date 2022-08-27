# frozen_string_literal: true

require 'shale/mapping/xml_group'

RSpec.describe Shale::Mapping::XmlGroup do
  describe '#name' do
    it 'returns name' do
      obj = described_class.new(:foo, :bar)
      expect(obj.name).to match('group_')
    end
  end

  describe '#map_element' do
    context 'when namespace is nil and prefix is not nil' do
      it 'raises an error' do
        obj = described_class.new(:foo, :bar)

        expect do
          obj.map_element('foo', namespace: nil, prefix: 'bar')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not nil and prefix is nil' do
      it 'raises an error' do
        obj = described_class.new(:foo, :bar)

        expect do
          obj.map_element('foo', namespace: 'bar', prefix: nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not set' do
      it 'will use default namespace' do
        obj = described_class.new(:foo, :bar)
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo')

        expect(obj.elements.keys).to eq(['http://default.com:foo'])
        expect(obj.elements['http://default.com:foo'].method_from).to eq(:foo)
        expect(obj.elements['http://default.com:foo'].method_to).to eq(:bar)
        expect(obj.elements['http://default.com:foo'].group).to eq(obj.name)
        expect(obj.elements['http://default.com:foo'].namespace.name).to eq('http://default.com')
        expect(obj.elements['http://default.com:foo'].namespace.prefix).to eq('default')
      end
    end

    context 'when namespace and prefix is nil' do
      it 'will set namespace and prefix to nil' do
        obj = described_class.new(:foo, :bar)
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', namespace: nil, prefix: nil)

        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].method_from).to eq(:foo)
        expect(obj.elements['foo'].method_to).to eq(:bar)
        expect(obj.elements['foo'].group).to eq(obj.name)
        expect(obj.elements['foo'].namespace.name).to eq(nil)
        expect(obj.elements['foo'].namespace.prefix).to eq(nil)
      end
    end

    context 'when namespace and prefix is set' do
      it 'will set namespace and prefix to provided values' do
        obj = described_class.new(:foo, :bar)
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.elements.keys).to eq(['http://custom.com:foo'])
        expect(obj.elements['http://custom.com:foo'].method_from).to eq(:foo)
        expect(obj.elements['http://custom.com:foo'].method_to).to eq(:bar)
        expect(obj.elements['http://custom.com:foo'].group).to eq(obj.name)
        expect(obj.elements['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.elements['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end
  end

  describe '#map_attribute' do
    context 'when namespace is nil and prefix is not nil' do
      it 'raises an error' do
        obj = described_class.new(:foo, :bar)

        expect do
          obj.map_attribute('foo', namespace: nil, prefix: 'bar')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not nil and prefix is nil' do
      it 'raises an error' do
        obj = described_class.new(:foo, :bar)

        expect do
          obj.map_attribute('foo', namespace: 'bar', prefix: nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace and prefix is set' do
      it 'will set namespace and prefix to provided values' do
        obj = described_class.new(:foo, :bar)

        obj.map_attribute('foo', namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.attributes.keys).to eq(['http://custom.com:foo'])
        expect(obj.attributes['http://custom.com:foo'].method_from).to eq(:foo)
        expect(obj.attributes['http://custom.com:foo'].method_to).to eq(:bar)
        expect(obj.attributes['http://custom.com:foo'].group).to eq(obj.name)
        expect(obj.attributes['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.attributes['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end

    context 'when default namespace is set' do
      it 'will not use default namespace' do
        obj = described_class.new(:foo, :bar)
        obj.namespace 'http://default.com', 'default'

        obj.map_attribute('foo')

        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].method_from).to eq(:foo)
        expect(obj.attributes['foo'].method_to).to eq(:bar)
        expect(obj.attributes['foo'].group).to eq(obj.name)
        expect(obj.attributes['foo'].namespace.name).to eq(nil)
        expect(obj.attributes['foo'].namespace.prefix).to eq(nil)
      end
    end
  end

  describe '#map_content' do
    it 'adds content mapping' do
      obj = described_class.new(:foo, :bar)
      obj.map_content
      expect(obj.content.method_from).to eq(:foo)
      expect(obj.content.method_to).to eq(:bar)
      expect(obj.content.group).to eq(obj.name)
    end
  end
end
