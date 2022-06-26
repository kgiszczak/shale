# frozen_string_literal: true

require 'nokogiri'
require 'shale/adapter/nokogiri'

RSpec.describe Shale::Adapter::Nokogiri do
  describe '.load' do
    context 'with valid XML document' do
      it 'parses XML document' do
        doc = described_class.load('<foo></foo>')
        expect(doc.name).to eq('foo')
      end
    end

    context 'with invalid XML document' do
      it 'raises an error' do
        expect do
          described_class.load('<foo')
        end.to raise_error(Shale::ParseError)
      end
    end
  end

  describe '.dump' do
    let(:doc) do
      doc = ::Nokogiri::XML::Document.new
      foo = ::Nokogiri::XML::Element.new('foo', doc)
      doc.add_child(foo)
      bar = ::Nokogiri::XML::Element.new('bar', doc)
      bar.content = 'Hello'
      foo.add_child(bar)
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
        expected = <<~XML
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
        expect(xml).to eq("<?xml version=\"1.0\"?><foo><bar>Hello</bar></foo>\n")
      end
    end

    context 'with :pretty and :declaration param' do
      it 'generates XML document with declaration and formats it' do
        xml = described_class.dump(doc, :pretty, :declaration)
        expected = <<~XML
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
    it 'returns instance of Shale::Adapter::Nokogiri::Document' do
      doc = described_class.create_document
      expect(doc.class).to eq(Shale::Adapter::Nokogiri::Document)
    end
  end
end
