# frozen_string_literal: true

require 'shale/mapping/xml'

RSpec.describe Shale::Mapping::Xml do
  describe '#elements' do
    it 'returns elements hash' do
      obj = described_class.new
      expect(obj.elements).to eq({})
    end
  end

  describe '#attributes' do
    it 'returns attributes hash' do
      obj = described_class.new
      expect(obj.attributes).to eq({})
    end
  end

  describe '#content' do
    it 'returns content value' do
      obj = described_class.new
      expect(obj.content).to eq(nil)
    end
  end

  describe '#default_namespace' do
    context 'when namespace is not set' do
      it 'returns value without prefix' do
        obj = described_class.new
        obj.root 'foo'

        expect(obj.prefixed_root).to eq('foo')
      end
    end

    context 'when namespace is set' do
      it 'returns value with prefix' do
        obj = described_class.new
        obj.root 'foo'
        obj.namespace 'http://bar.com', 'bar'

        expect(obj.prefixed_root).to eq('bar:foo')
      end
    end
  end

  describe '#prefixed_root' do
    it 'returns default namespace' do
      obj = described_class.new
      expect(obj.default_namespace.name).to eq(nil)
      expect(obj.default_namespace.prefix).to eq(nil)
    end
  end

  describe '#map_element' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].attribute).to eq(:bar)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_element('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_element('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to elements hash' do
          obj = described_class.new
          obj.map_element('foo', using: { from: :foo, to: :bar })
          expect(obj.elements.keys).to eq(['foo'])
          expect(obj.elements['foo'].method_from).to eq(:foo)
          expect(obj.elements['foo'].method_to).to eq(:bar)
        end
      end
    end

    context 'when namespace is nil and prefix is not nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('foo', to: :foo, namespace: nil, prefix: 'bar')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not nil and prefix is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('foo', to: :foo, namespace: 'bar', prefix: nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not set' do
      it 'it will use default namespace' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo)

        expect(obj.elements.keys).to eq(['http://default.com:foo'])
        expect(obj.elements['http://default.com:foo'].namespace.name).to eq('http://default.com')
        expect(obj.elements['http://default.com:foo'].namespace.prefix).to eq('default')
      end
    end

    context 'when namespace and prefix is nil' do
      it 'it will set namespace and prefix to nil' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo, namespace: nil, prefix: nil)

        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].namespace.name).to eq(nil)
        expect(obj.elements['foo'].namespace.prefix).to eq(nil)
      end
    end

    context 'when namespace and prefix is set' do
      it 'it will set namespace and prefix to provided values' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo, namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.elements.keys).to eq(['http://custom.com:foo'])
        expect(obj.elements['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.elements['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end
  end

  describe '#map_attribute' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :bar)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].attribute).to eq(:bar)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_attribute('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_attribute('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to attributes hash' do
          obj = described_class.new
          obj.map_attribute('foo', using: { from: :foo, to: :bar })
          expect(obj.attributes.keys).to eq(['foo'])
          expect(obj.attributes['foo'].method_from).to eq(:foo)
          expect(obj.attributes['foo'].method_to).to eq(:bar)
        end
      end
    end

    context 'when namespace is nil and prefix is not nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('foo', to: :foo, namespace: nil, prefix: 'bar')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is not nil and prefix is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('foo', to: :foo, namespace: 'bar', prefix: nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace and prefix is set' do
      it 'it will set namespace and prefix to provided values' do
        obj = described_class.new

        obj.map_attribute('foo', to: :foo, namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.attributes.keys).to eq(['http://custom.com:foo'])
        expect(obj.attributes['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.attributes['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end

    context 'when default namespace is set' do
      it 'it will not use default namespace' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_attribute('foo', to: :foo)

        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].namespace.name).to eq(nil)
        expect(obj.attributes['foo'].namespace.prefix).to eq(nil)
      end
    end
  end

  describe '#map_content' do
    it 'adds mapping to attributes hash' do
      obj = described_class.new
      obj.map_content(to: :bar)
      expect(obj.content).to eq(:bar)
    end
  end

  describe '#root' do
    it 'sets the root variable' do
      obj = described_class.new
      obj.root('foo')
      expect(obj.prefixed_root).to eq('foo')
    end
  end

  describe '#initialize_dup' do
    it 'duplicates instance variables' do
      original = described_class.new
      original.root('root')
      original.namespace('http://original.com', 'original')
      original.map_element('element', to: :element)
      original.map_attribute('attribute', to: :attribute)
      original.map_content(to: :content)

      duplicate = original.dup
      duplicate.root('root_dup')
      duplicate.map_element('element_dup', to: :element_dup)
      duplicate.map_attribute('attribute_dup', to: :attribute_dup)
      duplicate.map_content(to: :content_dup)

      expect(original.prefixed_root).to eq('original:root')
      expect(original.default_namespace.name).to eq('http://original.com')
      expect(original.default_namespace.prefix).to eq('original')
      expect(original.elements.keys).to eq(['http://original.com:element'])
      expect(original.elements['http://original.com:element'].attribute).to eq(:element)
      expect(original.attributes.keys).to eq(['attribute'])
      expect(original.attributes['attribute'].attribute).to eq(:attribute)
      expect(original.content).to eq(:content)

      expect(duplicate.prefixed_root).to eq('original:root_dup')
      expect(duplicate.elements.keys).to(
        eq(%w[http://original.com:element http://original.com:element_dup])
      )
      expect(duplicate.elements['http://original.com:element'].attribute).to eq(:element)
      expect(duplicate.elements['http://original.com:element_dup'].attribute).to eq(:element_dup)
      expect(duplicate.attributes.keys).to eq(%w[attribute attribute_dup])
      expect(duplicate.attributes['attribute'].attribute).to eq(:attribute)
      expect(duplicate.attributes['attribute_dup'].attribute).to eq(:attribute_dup)
      expect(duplicate.content).to eq(:content_dup)
    end
  end
end
