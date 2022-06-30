# frozen_string_literal: true

require 'nokogiri'
require 'shale/adapter/nokogiri/node'

RSpec.describe Shale::Adapter::Nokogiri::Node do
  describe '#namespaces' do
    context 'without namespaces' do
      it 'returns empty hash' do
        doc = ::Nokogiri::XML::Document.new
        el = ::Nokogiri::XML::Element.new('bar', doc)

        node = described_class.new(el)
        expect(node.namespaces).to eq({})
      end
    end

    context 'with namespaces' do
      it 'returns namespaces' do
        doc = ::Nokogiri::XML::Document.new
        el = ::Nokogiri::XML::Element.new('bar', doc)
        el.add_namespace(nil, 'http://default.com')
        el.add_namespace('foo', 'http://foo.com')
        el.add_namespace('bar', 'http://bar.com')

        node = described_class.new(el)

        expected = {
          'xmlns' => 'http://default.com',
          'foo' => 'http://foo.com',
          'bar' => 'http://bar.com',
        }

        expect(node.namespaces).to eq(expected)
      end
    end
  end

  describe '#name' do
    context 'with simple name' do
      it 'returns name of the node' do
        doc = ::Nokogiri::XML::Document.new
        el = ::Nokogiri::XML::Element.new('foo', doc)
        node = described_class.new(el)
        expect(node.name).to eq('foo')
      end
    end

    context 'with namespaced name' do
      it 'returns name of the node' do
        doc = ::Nokogiri::XML::Document.new
        el = ::Nokogiri::XML::Element.new('bar', doc)
        el.add_namespace(nil, 'http://foo.com')

        node = described_class.new(el)
        expect(node.name).to eq('http://foo.com:bar')
      end
    end
  end

  describe '#attributes' do
    it "returns node's attributes" do
      doc = ::Nokogiri::XML::Document.new
      el = ::Nokogiri::XML::Element.new('foo', doc)
      el.add_namespace('ns1', 'http://ns1.com')
      el.add_namespace('ns2', 'http://ns2.com')

      el['foo'] = 'foo-value'
      el['bar'] = 'bar-value'
      el['baz'] = 'baz-value'

      el['ns1:foo'] = 'ns1-foo-value'
      el['ns2:bar'] = 'ns2-bar-value'

      node = described_class.new(el)

      expect(node.attributes['foo']).to eq('foo-value')
      expect(node.attributes['bar']).to eq('bar-value')
      expect(node.attributes['baz']).to eq('baz-value')
      expect(node.attributes['http://ns1.com:foo']).to eq('ns1-foo-value')
      expect(node.attributes['http://ns2.com:bar']).to eq('ns2-bar-value')
    end
  end

  describe '#parent' do
    context 'when parent is present' do
      it 'returns parent node' do
        doc = ::Nokogiri::XML::Document.parse('<parent><child>foo</child></parent>')
        node = described_class.new(doc.root)
        expect(node.children[0].parent.name).to eq('parent')
      end
    end

    context 'when parent is not present' do
      it 'returns nil' do
        doc = ::Nokogiri::XML::Document.parse('<parent><child>foo</child></parent>')
        node = described_class.new(doc)
        expect(node.parent).to eq(nil)
      end
    end

    context 'when parent is document' do
      it 'returns nil' do
        doc = ::Nokogiri::XML::Document.parse('<parent><child>foo</child></parent>')
        node = described_class.new(doc.root)
        expect(node.parent).to eq(nil)
      end
    end
  end

  describe '#children' do
    it 'returns element nodes' do
      doc = ::Nokogiri::XML::Document.parse('<root><a/>text1<b/>text2<c/></root>')
      node = described_class.new(doc.root)
      expect(node.children.map(&:name)).to eq(%w[a b c])
    end
  end

  describe '#text' do
    context 'with plain text' do
      it 'returns text nodes' do
        doc = ::Nokogiri::XML::Document.parse('<root><a/>text1<b/>text2<c/></root>')
        node = described_class.new(doc.root)
        expect(node.text).to eq('text1')
      end
    end

    context 'with cdata' do
      it 'returns text nodes' do
        doc = ::Nokogiri::XML::Document.parse('<root><a/><![CDATA[text1]]><b/>text2<c/></root>')
        node = described_class.new(doc.root)
        expect(node.text).to eq('text1')
      end
    end
  end
end
