# frozen_string_literal: true

require 'nokogiri'
require 'shale/adapter/nokogiri/document'

RSpec.describe Shale::Adapter::Nokogiri::Document do
  subject(:doc) { described_class.new }

  describe '#intialize' do
    it 'accepts version parameter' do
      instance = described_class.new('foobar')
      expect(instance.doc.version).to eq('foobar')
    end
  end

  describe '#doc' do
    context 'without namespaces' do
      it 'returns Nokogiri::XML::Document instance' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)

        expect(doc.doc.class).to eq(Nokogiri::XML::Document)
        expect(doc.doc.root.namespaces).to eq({})
      end
    end

    context 'with namespaces' do
      it 'returns REXML::Document instance' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)
        doc.add_namespace('foo', 'http://foo.com')

        expect(doc.doc.class).to eq(Nokogiri::XML::Document)
        expect(doc.doc.root.namespaces).to eq({ 'xmlns:foo' => 'http://foo.com' })
      end
    end
  end

  describe '#create_element' do
    it 'returns Nokogiri::XML::Element instance' do
      el = doc.create_element('foo')
      expect(el.class).to eq(Nokogiri::XML::Element)
      expect(el.name).to eq('foo')
    end
  end

  describe '#create_cdata' do
    it 'wraps text with CDATA and adds it to parent' do
      el = doc.create_element('foo')
      doc.create_cdata('bar', el)
      expect(el.to_s).to eq('<foo><![CDATA[bar]]></foo>')
    end
  end

  describe '#add_namespace' do
    context 'when prefix is nil' do
      it 'add namespace with default prefix to root element' do
        el = doc.create_element('foo')
        doc.add_element(doc.doc, el)
        doc.add_namespace(nil, 'http://foo.com')

        expect(doc.doc.root.namespaces).to eq({ "xmlns" => "http://foo.com" })
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

        expect(doc.doc.root.namespaces).to eq({ 'xmlns:foo' => 'http://foo.com' })
      end
    end
  end

  describe '#add_attribute' do
    context 'when value is nil' do
      it 'adds attribute to element' do
        el = doc.create_element('foo')
        doc.add_attribute(el, 'bar', nil)
        expect(el['bar']).to eq('')
      end
    end

    context 'when value is not nil' do
      it 'adds attribute to element' do
        el = doc.create_element('foo')
        doc.add_attribute(el, 'bar', 'baz')
        expect(el['bar']).to eq('baz')
      end
    end
  end

  describe '#add_element' do
    it 'adds child to element' do
      parent = doc.create_element('parent')
      child = doc.create_element('child')
      doc.add_element(parent, child)
      expect(parent.to_s).to eq("<parent>\n  <child/>\n</parent>")
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
