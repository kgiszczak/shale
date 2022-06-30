# frozen_string_literal: true

require 'ox'
require 'shale/adapter/ox/document'

RSpec.describe Shale::Adapter::Ox::Document do
  subject(:doc) { described_class.new }

  describe '#doc' do
    it 'returns Ox::Document instance' do
      expect(doc.doc.class).to eq(::Ox::Document)
    end
  end

  describe '#create_element' do
    it 'returns Ox::Element instance' do
      el = doc.create_element('foo')
      expect(el.class).to eq(::Ox::Element)
      expect(el.name).to eq('foo')
    end
  end

  describe '#create_cdata' do
    it 'wraps text with CDATA and adds it to parent' do
      el = doc.create_element('foo')
      doc.create_cdata('bar', el)
      expect(::Ox.dump(el)).to eq("\n<foo>\n  <![CDATA[bar]]>\n</foo>\n")
    end
  end

  # make sure the method is defined and accepts two arguments
  describe '#add_namespace' do
    it 'does nothing' do
      doc.add_namespace('foo', 'bar')
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
      expect(::Ox.dump(parent)).to eq("\n<parent>\n  <child/>\n</parent>\n")
    end
  end

  describe '#add_text' do
    it 'adds text to element' do
      parent = doc.create_element('parent')
      doc.add_text(parent, 'child')
      expect(::Ox.dump(parent)).to eq("\n<parent>child</parent>\n")
    end
  end
end
