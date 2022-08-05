# frozen_string_literal: true

require 'shale/mapping/descriptor/xml'
require 'shale/mapping/descriptor/xml_namespace'

RSpec.describe Shale::Mapping::Descriptor::Xml do
  describe '#initilize' do
    it 'delegates attributes to parent class' do
      obj = described_class.new(
        name: 'foo',
        attribute: :foo,
        methods: { from: :method_from, to: :method_to },
        namespace: nil,
        cdata: false,
        render_nil: true
      )

      expect(obj.name).to eq('foo')
      expect(obj.attribute).to eq(:foo)
      expect(obj.method_from).to eq(:method_from)
      expect(obj.method_to).to eq(:method_to)
      expect(obj.render_nil?).to eq(true)
    end
  end

  describe '#namespace' do
    it 'returns namespace' do
      nsp = Shale::Mapping::Descriptor::XmlNamespace.new

      obj = described_class.new(
        name: 'foo',
        attribute: :foo,
        methods: nil,
        namespace: nsp,
        cdata: false,
        render_nil: false
      )

      expect(obj.namespace).to eq(nsp)
    end
  end

  describe '#cdata' do
    it 'returns cdata' do
      obj = described_class.new(
        name: 'foo',
        attribute: :foo,
        methods: nil,
        namespace: nil,
        cdata: true,
        render_nil: false
      )

      expect(obj.cdata).to eq(true)
    end
  end

  describe '#prefixed_name' do
    context 'when prefix is present' do
      it 'returns name prefixed by namespace prefix' do
        obj = described_class.new(
          name: 'foo',
          attribute: :foo,
          methods: nil,
          namespace: Shale::Mapping::Descriptor::XmlNamespace.new('http://bar.com', 'bar'),
          cdata: false,
          render_nil: false
        )

        expect(obj.prefixed_name).to eq('bar:foo')
      end
    end

    context 'when prefix is not present' do
      it 'returns name' do
        obj = described_class.new(
          name: 'foo',
          attribute: :foo,
          methods: nil,
          namespace: Shale::Mapping::Descriptor::XmlNamespace.new,
          cdata: false,
          render_nil: false
        )

        expect(obj.prefixed_name).to eq('foo')
      end
    end
  end
end
