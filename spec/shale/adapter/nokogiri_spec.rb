# frozen_string_literal: true

require 'nokogiri'
require 'shale/adapter/nokogiri'

RSpec.describe Shale::Adapter::Nokogiri do
  describe '.load' do
    it 'parses XML document' do
      doc = described_class.load('<foo></foo>')
      expect(doc.name).to eq('foo')
    end
  end

  describe '.dump' do
    it 'generates XML document' do
      doc = ::Nokogiri::XML::Document.new
      el = ::Nokogiri::XML::Element.new('foo', doc)
      doc.add_child(el)
      xml = described_class.dump(doc)
      expect(xml).to eq("<?xml version=\"1.0\"?>\n<foo/>\n")
    end
  end

  describe '.create_document' do
    it 'returns instance of Shale::Adapter::Nokogiri::Document' do
      doc = described_class.create_document
      expect(doc.class).to eq(Shale::Adapter::Nokogiri::Document)
    end
  end
end

RSpec.describe Shale::Adapter::Nokogiri::Document do
  subject(:doc) { described_class.new }

  describe '#doc' do
    it 'returns Nokogiri::XML::Document instance' do
      expect(doc.doc.class).to eq(::Nokogiri::XML::Document)
    end
  end

  describe '#create_element' do
    it 'returns Nokogiri::XML::Element instance' do
      el = doc.create_element('foo')
      expect(el.class).to eq(::Nokogiri::XML::Element)
      expect(el.name).to eq('foo')
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

RSpec.describe Shale::Adapter::Nokogiri::Node do
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
        el = ::Nokogiri::XML::Element.new('foo:bar', doc)
        node = described_class.new(el)
        expect(node.name).to eq('foo:bar')
      end
    end
  end

  describe '#attributes' do
    it "returns node's attributes" do
      doc = ::Nokogiri::XML::Document.new
      el = ::Nokogiri::XML::Element.new('foo', doc)
      el['foo'] = 'foo-value'
      el['bar'] = 'bar-value'
      el['baz'] = 'baz-value'
      node = described_class.new(el)
      expect(node.attributes['foo']).to eq('foo-value')
      expect(node.attributes['bar']).to eq('bar-value')
      expect(node.attributes['baz']).to eq('baz-value')
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
    it 'returns text nodes' do
      doc = ::Nokogiri::XML::Document.parse('<root><a/>text1<b/>text2<c/></root>')
      node = described_class.new(doc.root)
      expect(node.text).to eq('text1')
    end
  end
end
