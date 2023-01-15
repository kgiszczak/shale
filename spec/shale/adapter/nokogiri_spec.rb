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
    let(:version) { nil }

    let(:doc) do
      doc = Nokogiri::XML::Document.new(version)
      foo = Nokogiri::XML::Element.new('foo', doc)
      doc.add_child(foo)
      bar = Nokogiri::XML::Element.new('bar', doc)
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

    context 'with pretty: true param' do
      it 'generates XML document and formats it' do
        xml = described_class.dump(doc, pretty: true)
        expected = <<~XML
          <foo>
            <bar>Hello</bar>
          </foo>
        XML

        expect(xml).to eq(expected)
      end
    end

    context 'with declaration: true param' do
      it 'generates XML document with declaration' do
        xml = described_class.dump(doc, declaration: true)
        expect(xml).to eq("<?xml version=\"1.0\"?><foo><bar>Hello</bar></foo>\n")
      end
    end

    context 'with pretty: true and declaration: true param' do
      it 'generates XML document with declaration and formats it' do
        xml = described_class.dump(doc, pretty: true, declaration: true)
        expected = <<~XML
          <?xml version="1.0"?>
          <foo>
            <bar>Hello</bar>
          </foo>
        XML

        expect(xml).to eq(expected)
      end
    end

    context 'when declaration is nil' do
      it 'generates XML document without declaration' do
        xml = described_class.dump(doc, declaration: nil)
        expect(xml).to eq('<foo><bar>Hello</bar></foo>')
      end
    end

    context 'when declaration is string' do
      let(:version) { '1.1' }

      it 'generates XML document with declaration' do
        xml = described_class.dump(doc, declaration: true)
        expect(xml).to eq("<?xml version=\"1.1\"?><foo><bar>Hello</bar></foo>\n")
      end
    end

    context 'when encoding is false' do
      it 'generates XML document without encoding' do
        xml = described_class.dump(doc, declaration: true, encoding: false)
        expect(xml).to eq("<?xml version=\"1.0\"?><foo><bar>Hello</bar></foo>\n")
      end
    end

    context 'when encoding is nil' do
      it 'generates XML document without encoding' do
        xml = described_class.dump(doc, declaration: true, encoding: nil)
        expect(xml).to eq("<?xml version=\"1.0\"?><foo><bar>Hello</bar></foo>\n")
      end
    end

    context 'when encoding is true' do
      it 'generates XML document with encoding' do
        xml = described_class.dump(doc, declaration: true, encoding: true)
        expect(xml).to eq("<?xml version=\"1.0\" encoding=\"UTF-8\"?><foo><bar>Hello</bar></foo>\n")
      end
    end

    context 'when encoding is string' do
      it 'generates XML document with encoding' do
        xml = described_class.dump(doc, declaration: true, encoding: 'ASCII')
        expect(xml).to eq("<?xml version=\"1.0\" encoding=\"ASCII\"?><foo><bar>Hello</bar></foo>\n")
      end
    end
  end

  describe '.create_document' do
    it 'returns instance of Shale::Adapter::Nokogiri::Document' do
      doc = described_class.create_document
      expect(doc.class).to eq(Shale::Adapter::Nokogiri::Document)
    end

    it 'accepts one parameter and returns instance' do
      doc = described_class.create_document('foobar')
      expect(doc.class).to eq(Shale::Adapter::Nokogiri::Document)
      expect(doc.doc.version).to eq('foobar')
    end
  end
end
