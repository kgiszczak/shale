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
    it 'generates XML document' do
      el = ::REXML::Element.new('foo')
      doc = ::REXML::Document.new
      doc.add_element(el)
      xml = described_class.dump(doc)
      expect(xml).to eq('<foo/>')
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
    it 'returns REXML::Document instance' do
      expect(doc.doc.class).to eq(::REXML::Document)
    end
  end

  describe '#create_element' do
    it 'returns REXML::Element instance' do
      el = doc.create_element('foo')
      expect(el.class).to eq(::REXML::Element)
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
        el = ::REXML::Element.new('foo:bar')
        node = described_class.new(el)
        expect(node.name).to eq('foo:bar')
      end
    end
  end

  describe '#attributes' do
    it "returns node's attributes" do
      el = ::REXML::Element.new('foo')
      el.add_attribute('foo', 'foo-value')
      el.add_attribute('bar', 'bar-value')
      el.add_attribute('baz', 'baz-value')
      node = described_class.new(el)
      expect(node.attributes['foo']).to eq('foo-value')
      expect(node.attributes['bar']).to eq('bar-value')
      expect(node.attributes['baz']).to eq('baz-value')
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
