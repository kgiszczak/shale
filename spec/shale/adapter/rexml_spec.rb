# frozen_string_literal: true

require 'shale/adapter/rexml'

RSpec.describe Shale::Adapter::REXML do
  describe '.load' do
    it 'parses XML document' do
      doc = described_class.load('<foo></foo>')
      expect(doc.name).to eq('foo')
    end
  end

  describe '.dump' do
    let(:doc) do
      bar = ::REXML::Element.new('bar')
      bar.add_text('Hello')
      foo = ::REXML::Element.new('foo')
      foo.add_element(bar)
      doc = ::REXML::Document.new(nil, prologue_quote: :quote)
      doc.add_element(foo)
      doc
    end

    context 'with no params' do
      it 'generates XML document' do
        xml = described_class.dump(doc)
        expect(xml).to eq('<foo><bar>Hello</bar></foo>')
      end
    end

    context 'with :pretty param' do
      it 'generates XML document and formats it' do
        xml = described_class.dump(doc, :pretty)
        expected = <<~XML.gsub(/\n\z/, '')
          <foo>
            <bar>Hello</bar>
          </foo>
        XML

        expect(xml).to eq(expected)
      end
    end

    context 'with :declaration param' do
      it 'generates XML document with declaration' do
        xml = described_class.dump(doc, :declaration)
        expect(xml).to eq('<?xml version="1.0"?><foo><bar>Hello</bar></foo>')
      end
    end

    context 'with :pretty and :declaration param' do
      it 'generates XML document with declaration and formats it' do
        xml = described_class.dump(doc, :pretty, :declaration)
        expected = <<~XML.gsub(/\n\z/, '')
          <?xml version="1.0"?>
          <foo>
            <bar>Hello</bar>
          </foo>
        XML

        expect(xml).to eq(expected)
      end
    end
  end

  describe '.create_document' do
    it 'returns instance of Shale::Adapter::REXML::Document' do
      doc = described_class.create_document
      expect(doc.class).to eq(Shale::Adapter::REXML::Document)
    end
  end
end

RSpec.describe Shale::Adapter::REXML::Document do
  subject(:doc) { described_class.new }

  describe '#doc' do
    context 'without namespaces' do
      it 'returns REXML::Document instance' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)

        expect(doc.doc.class).to eq(::REXML::Document)
        expect(doc.doc.root.namespaces).to eq({})
      end
    end

    context 'with namespaces' do
      it 'returns REXML::Document instance' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)
        doc.add_namespace('foo', 'http://foo.com')

        expect(doc.doc.class).to eq(::REXML::Document)
        expect(doc.doc.root.namespaces).to eq({ 'foo' => 'http://foo.com' })
      end
    end
  end

  describe '#create_element' do
    it 'returns REXML::Element instance' do
      el = doc.create_element('foo')
      expect(el.class).to eq(::REXML::Element)
      expect(el.name).to eq('foo')
    end
  end

  describe '#add_namespace' do
    context 'when prefix is nil' do
      it 'does not add namespace to root element' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)
        doc.add_namespace(nil, 'http://foo.com')

        expect(doc.doc.root.namespaces).to eq({})
      end
    end

    context 'when namespace is nil' do
      it 'does not add namespace to root element' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)
        doc.add_namespace('foo', nil)

        expect(doc.doc.root.namespaces).to eq({})
      end
    end

    context 'when prefix and namespace are set' do
      it 'does not add namespace to root element' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)
        doc.add_namespace('foo', 'http://foo.com')

        expect(doc.doc.root.namespaces).to eq({ 'foo' => 'http://foo.com' })
      end
    end
  end

  describe '#add_attribute' do
    it 'adds attribute to element' do
      el = doc.create_element('foo')
      doc.add_attribute(el, 'bar', 'baz')
      expect(el['bar']).to eq('baz')
    end
  end

  describe '#add_element' do
    it 'adds child to element' do
      parent = doc.create_element('parent')
      child = doc.create_element('child')
      doc.add_element(parent, child)
      expect(parent.to_s).to eq('<parent><child/></parent>')
    end
  end

  describe '#add_text' do
    it 'adds text to element' do
      parent = doc.create_element('parent')
      doc.add_text(parent, 'child')
      expect(parent.to_s).to eq('<parent>child</parent>')
    end
  end
end

RSpec.describe Shale::Adapter::REXML::Node do
  describe '#name' do
    context 'with simple name' do
      it 'returns name of the node' do
        el = ::REXML::Element.new('foo')
        node = described_class.new(el)
        expect(node.name).to eq('foo')
      end
    end

    context 'with namespaced name' do
      it 'returns name of the node' do
        el = ::REXML::Element.new('bar')
        el.add_namespace(nil, 'http://foo.com')

        node = described_class.new(el)
        expect(node.name).to eq('http://foo.com:bar')
      end
    end
  end

  describe '#attributes' do
    it "returns node's attributes" do
      el = ::REXML::Element.new('foo')
      el.add_namespace('ns1', 'http://ns1.com')
      el.add_namespace('ns2', 'http://ns2.com')

      el.add_attribute('foo', 'foo-value')
      el.add_attribute('bar', 'bar-value')
      el.add_attribute('baz', 'baz-value')

      el.add_attribute('ns1:foo', 'ns1-foo-value')
      el.add_attribute('ns2:bar', 'ns2-bar-value')

      node = described_class.new(el)

      expect(node.attributes['foo']).to eq('foo-value')
      expect(node.attributes['bar']).to eq('bar-value')
      expect(node.attributes['baz']).to eq('baz-value')
      expect(node.attributes['http://ns1.com:foo']).to eq('ns1-foo-value')
      expect(node.attributes['http://ns2.com:bar']).to eq('ns2-bar-value')
    end
  end

  describe '#children' do
    it 'returns element nodes' do
      doc = ::REXML::Document.new('<root><a/>text1<b/>text2<c/></root>')
      node = described_class.new(doc.root)
      expect(node.children.map(&:name)).to eq(%w[a b c])
    end
  end

  describe '#text' do
    it 'returns text nodes' do
      doc = ::REXML::Document.new('<root><a/>text1<b/>text2<c/></root>')
      node = described_class.new(doc.root)
      expect(node.text).to eq('text1')
    end
  end
end
