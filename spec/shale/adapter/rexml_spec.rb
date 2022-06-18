# frozen_string_literal: true

require 'rexml'
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
