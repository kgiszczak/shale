# frozen_string_literal: true

require 'ox'
require 'shale/adapter/ox/node'

RSpec.describe Shale::Adapter::Ox::Node do
  describe '#namespaces' do
    it 'returns empty hash' do
      el = ::Ox::Element.new('foo')
      node = described_class.new(el)

      expect(node.namespaces).to eq({})
    end
  end

  describe '#name' do
    context 'with simple name' do
      it 'returns name of the node' do
        el = ::Ox::Element.new('foo')
        node = described_class.new(el)
        expect(node.name).to eq('foo')
      end
    end

    context 'with namespaced name' do
      it 'returns name of the node' do
        el = ::Ox::Element.new('foo:bar')
        node = described_class.new(el)
        expect(node.name).to eq('foo:bar')
      end
    end
  end

  describe '#attributes' do
    it "returns node's attributes" do
      el = ::Ox::Element.new('foo')
      el['foo'] = 'foo-value'
      el['bar'] = 'bar-value'
      el['baz'] = 'baz-value'
      node = described_class.new(el)
      expect(node.attributes['foo']).to eq('foo-value')
      expect(node.attributes['bar']).to eq('bar-value')
      expect(node.attributes['baz']).to eq('baz-value')
    end
  end

  describe '#parent' do
    it 'returns nil' do
      doc = ::Ox.parse('<parent><child>foo</child></parent>')
      node = described_class.new(doc)
      expect(node.children[0].parent).to eq(nil)
    end
  end

  describe '#children' do
    it 'returns element nodes' do
      doc = ::Ox.parse('<root><a/>text1<b/>text2<c/></root>')
      node = described_class.new(doc)
      expect(node.children.map(&:name)).to eq(%w[a b c])
    end
  end

  describe '#text' do
    context 'with plain text' do
      it 'returns text nodes' do
        doc = ::Ox.parse('<root><a/>text1<b/>text2<c/></root>')
        node = described_class.new(doc)
        expect(node.text).to eq('text1')
      end
    end

    context 'with cdata' do
      it 'returns text nodes' do
        doc = ::Ox.parse('<root><a/><![CDATA[text1]]><b/>text2<c/></root>')
        node = described_class.new(doc)
        expect(node.text).to eq('text1')
      end
    end
  end
end
