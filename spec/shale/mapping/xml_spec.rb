# frozen_string_literal: true

require 'shale/mapping/xml'

RSpec.describe Shale::Mapping::Xml do
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

    context 'when :to is nil and :receiver and :using is present' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('key', to: nil, receiver: :foo, using: {})
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :receiver is not nil' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar, receiver: :baz)

        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].receiver).to eq(:baz)
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
      it 'will use default namespace' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo)

        expect(obj.elements.keys).to eq(['http://default.com:foo'])
        expect(obj.elements['http://default.com:foo'].namespace.name).to eq('http://default.com')
        expect(obj.elements['http://default.com:foo'].namespace.prefix).to eq('default')
      end
    end

    context 'when namespace and prefix is nil' do
      it 'will set namespace and prefix to nil' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo, namespace: nil, prefix: nil)

        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].namespace.name).to eq(nil)
        expect(obj.elements['foo'].namespace.prefix).to eq(nil)
      end
    end

    context 'when namespace and prefix is set' do
      it 'will set namespace and prefix to provided values' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_element('foo', to: :foo, namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.elements.keys).to eq(['http://custom.com:foo'])
        expect(obj.elements['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.elements['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end

    context 'when :cdata is set' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar, cdata: true)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].cdata).to eq(true)
      end
    end

    context 'when :render_nil is set' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar, render_nil: true)
        expect(obj.elements.keys).to eq(['foo'])
        expect(obj.elements['foo'].render_nil?).to eq(true)
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

      context 'when :to is nil and :receiver and :using is present' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_attribute('key', to: nil, receiver: :foo, using: {})
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :receiver is not nil' do
        it 'adds mapping to attributes hash' do
          obj = described_class.new
          obj.map_attribute('foo', to: :bar, receiver: :baz)

          expect(obj.attributes.keys).to eq(['foo'])
          expect(obj.attributes['foo'].receiver).to eq(:baz)
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
      it 'will set namespace and prefix to provided values' do
        obj = described_class.new

        obj.map_attribute('foo', to: :foo, namespace: 'http://custom.com', prefix: 'custom')

        expect(obj.attributes.keys).to eq(['http://custom.com:foo'])
        expect(obj.attributes['http://custom.com:foo'].namespace.name).to eq('http://custom.com')
        expect(obj.attributes['http://custom.com:foo'].namespace.prefix).to eq('custom')
      end
    end

    context 'when default namespace is set' do
      it 'will not use default namespace' do
        obj = described_class.new
        obj.namespace 'http://default.com', 'default'

        obj.map_attribute('foo', to: :foo)

        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].namespace.name).to eq(nil)
        expect(obj.attributes['foo'].namespace.prefix).to eq(nil)
      end
    end

    context 'when :render_nil is set' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :bar, render_nil: true)
        expect(obj.attributes.keys).to eq(['foo'])
        expect(obj.attributes['foo'].render_nil?).to eq(true)
      end
    end
  end

  describe '#map_content' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_content
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds content mapping' do
        obj = described_class.new
        obj.map_content(to: :bar)
        expect(obj.content.attribute).to eq(:bar)
      end
    end

    context 'when :to is nil and :receiver and :using is present' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_content(to: nil, receiver: :foo, using: {})
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :receiver is not nil' do
      it 'adds content mapping' do
        obj = described_class.new
        obj.map_content(to: :bar, receiver: :baz)

        expect(obj.content.receiver).to eq(:baz)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_content(using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_content(using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds content mapping' do
          obj = described_class.new
          obj.map_content(using: { from: :foo, to: :bar })
          expect(obj.content.method_from).to eq(:foo)
          expect(obj.content.method_to).to eq(:bar)
        end
      end
    end

    context 'when :cdata is set' do
      it 'adds content mapping' do
        obj = described_class.new
        obj.map_content(to: :bar, cdata: true)
        expect(obj.content.cdata).to eq(true)
      end
    end
  end

  describe '#group' do
    context 'without namespaces' do
      it 'creates methods mappings' do
        obj = described_class.new

        obj.group(from: :foo, to: :bar) do
          map_content
          map_element('bar')
          map_attribute('baz')
        end

        expect(obj.content.attribute).to eq(nil)
        expect(obj.content.method_from).to eq(:foo)
        expect(obj.content.method_to).to eq(:bar)
        expect(obj.content.group).to match('group_')
        expect(obj.content.namespace.name).to eq(nil)
        expect(obj.content.namespace.prefix).to eq(nil)

        expect(obj.elements.keys).to eq(%w[bar])
        expect(obj.elements['bar'].attribute).to eq(nil)
        expect(obj.elements['bar'].method_from).to eq(:foo)
        expect(obj.elements['bar'].method_to).to eq(:bar)
        expect(obj.elements['bar'].group).to match('group_')
        expect(obj.elements['bar'].namespace.name).to eq(nil)
        expect(obj.elements['bar'].namespace.prefix).to eq(nil)

        expect(obj.attributes.keys).to eq(%w[baz])
        expect(obj.attributes['baz'].attribute).to eq(nil)
        expect(obj.attributes['baz'].method_from).to eq(:foo)
        expect(obj.attributes['baz'].method_to).to eq(:bar)
        expect(obj.attributes['baz'].group).to match('group_')
        expect(obj.attributes['baz'].namespace.name).to eq(nil)
        expect(obj.attributes['baz'].namespace.prefix).to eq(nil)
      end
    end

    context 'with namespaces' do
      it 'creates methods mappings' do
        obj = described_class.new

        obj.group(from: :foo, to: :bar) do
          map_content
          map_element('bar', namespace: 'http://foo.com', prefix: 'foo')
          map_attribute('baz', namespace: 'http://foo.com', prefix: 'foo')
        end

        expect(obj.content.attribute).to eq(nil)
        expect(obj.content.method_from).to eq(:foo)
        expect(obj.content.method_to).to eq(:bar)
        expect(obj.content.group).to match('group_')
        expect(obj.content.namespace.name).to eq(nil)
        expect(obj.content.namespace.prefix).to eq(nil)

        expect(obj.elements.keys).to eq(%w[http://foo.com:bar])
        expect(obj.elements['http://foo.com:bar'].attribute).to eq(nil)
        expect(obj.elements['http://foo.com:bar'].method_from).to eq(:foo)
        expect(obj.elements['http://foo.com:bar'].method_to).to eq(:bar)
        expect(obj.elements['http://foo.com:bar'].group).to match('group_')
        expect(obj.elements['http://foo.com:bar'].namespace.name).to eq('http://foo.com')
        expect(obj.elements['http://foo.com:bar'].namespace.prefix).to eq('foo')

        expect(obj.attributes.keys).to eq(%w[http://foo.com:baz])
        expect(obj.attributes['http://foo.com:baz'].attribute).to eq(nil)
        expect(obj.attributes['http://foo.com:baz'].method_from).to eq(:foo)
        expect(obj.attributes['http://foo.com:baz'].method_to).to eq(:bar)
        expect(obj.attributes['http://foo.com:baz'].group).to match('group_')
        expect(obj.attributes['http://foo.com:baz'].namespace.name).to eq('http://foo.com')
        expect(obj.attributes['http://foo.com:baz'].namespace.prefix).to eq('foo')
      end
    end

    context 'with default namespace' do
      it 'creates methods mappings' do
        obj = described_class.new

        obj.namespace('http://foo.com', 'foo')
        obj.group(from: :foo, to: :bar) do
          map_content
          map_element('bar')
          map_attribute('baz')
        end

        expect(obj.content.attribute).to eq(nil)
        expect(obj.content.method_from).to eq(:foo)
        expect(obj.content.method_to).to eq(:bar)
        expect(obj.content.group).to match('group_')
        expect(obj.content.namespace.name).to eq(nil)
        expect(obj.content.namespace.prefix).to eq(nil)

        expect(obj.elements.keys).to eq(%w[http://foo.com:bar])
        expect(obj.elements['http://foo.com:bar'].attribute).to eq(nil)
        expect(obj.elements['http://foo.com:bar'].method_from).to eq(:foo)
        expect(obj.elements['http://foo.com:bar'].method_to).to eq(:bar)
        expect(obj.elements['http://foo.com:bar'].group).to match('group_')
        expect(obj.elements['http://foo.com:bar'].namespace.name).to eq('http://foo.com')
        expect(obj.elements['http://foo.com:bar'].namespace.prefix).to eq('foo')

        expect(obj.attributes.keys).to eq(%w[baz])
        expect(obj.attributes['baz'].attribute).to eq(nil)
        expect(obj.attributes['baz'].method_from).to eq(:foo)
        expect(obj.attributes['baz'].method_to).to eq(:bar)
        expect(obj.attributes['baz'].group).to match('group_')
        expect(obj.attributes['baz'].namespace.name).to eq(nil)
        expect(obj.attributes['baz'].namespace.prefix).to eq(nil)
      end
    end

    context 'with default and specific namespace' do
      it 'creates methods mappings' do
        obj = described_class.new

        obj.namespace('http://foo.com', 'foo')
        obj.group(from: :foo, to: :bar) do
          map_content
          map_element('bar', namespace: 'http://bar.com', prefix: 'bar')
          map_attribute('baz', namespace: 'http://bar.com', prefix: 'bar')
        end

        expect(obj.content.attribute).to eq(nil)
        expect(obj.content.method_from).to eq(:foo)
        expect(obj.content.method_to).to eq(:bar)
        expect(obj.content.group).to match('group_')
        expect(obj.content.namespace.name).to eq(nil)
        expect(obj.content.namespace.prefix).to eq(nil)

        expect(obj.elements.keys).to eq(%w[http://bar.com:bar])
        expect(obj.elements['http://bar.com:bar'].attribute).to eq(nil)
        expect(obj.elements['http://bar.com:bar'].method_from).to eq(:foo)
        expect(obj.elements['http://bar.com:bar'].method_to).to eq(:bar)
        expect(obj.elements['http://bar.com:bar'].group).to match('group_')
        expect(obj.elements['http://bar.com:bar'].namespace.name).to eq('http://bar.com')
        expect(obj.elements['http://bar.com:bar'].namespace.prefix).to eq('bar')

        expect(obj.attributes.keys).to eq(%w[http://bar.com:baz])
        expect(obj.attributes['http://bar.com:baz'].attribute).to eq(nil)
        expect(obj.attributes['http://bar.com:baz'].method_from).to eq(:foo)
        expect(obj.attributes['http://bar.com:baz'].method_to).to eq(:bar)
        expect(obj.attributes['http://bar.com:baz'].group).to match('group_')
        expect(obj.attributes['http://bar.com:baz'].namespace.name).to eq('http://bar.com')
        expect(obj.attributes['http://bar.com:baz'].namespace.prefix).to eq('bar')
      end
    end
  end
end
