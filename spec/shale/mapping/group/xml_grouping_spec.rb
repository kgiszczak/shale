# frozen_string_literal: true

require 'shale/mapping/group/xml_grouping'
require 'shale/mapping/descriptor/xml'
require 'shale/mapping/descriptor/xml_namespace'

RSpec.describe Shale::Mapping::Group::XmlGrouping do
  describe '#add' do
    it 'adds a group for a mapping' do
      instance = described_class.new

      mapping = Shale::Mapping::Descriptor::Xml.new(
        name: nil,
        attribute: nil,
        methods: { from: :met_from, to: :met_to },
        group: 'group1',
        namespace: Shale::Mapping::Descriptor::XmlNamespace.new,
        cdata: false,
        render_nil: false
      )

      instance.add(mapping, :content, 'val1')

      mapping = Shale::Mapping::Descriptor::Xml.new(
        name: 'foo',
        attribute: nil,
        methods: { from: :met_from, to: :met_to },
        group: 'group1',
        namespace: Shale::Mapping::Descriptor::XmlNamespace.new,
        cdata: false,
        render_nil: false
      )

      instance.add(mapping, :element, 'val2')

      mapping = Shale::Mapping::Descriptor::Xml.new(
        name: 'bar',
        attribute: nil,
        methods: { from: :met_from, to: :met_to },
        group: 'group1',
        namespace: Shale::Mapping::Descriptor::XmlNamespace.new,
        cdata: false,
        render_nil: false
      )

      instance.add(mapping, :attribute, 'val3')

      mapping = Shale::Mapping::Descriptor::Xml.new(
        name: nil,
        attribute: nil,
        methods: { from: :met_from_alt, to: :met_to_alt },
        group: 'group2',
        namespace: Shale::Mapping::Descriptor::XmlNamespace.new('http://foo.com', 'foo'),
        cdata: false,
        render_nil: false
      )

      instance.add(mapping, :content, 'val1')

      mapping = Shale::Mapping::Descriptor::Xml.new(
        name: 'foo',
        attribute: nil,
        methods: { from: :met_from_alt, to: :met_to_alt },
        group: 'group2',
        namespace: Shale::Mapping::Descriptor::XmlNamespace.new('http://foo.com', 'foo'),
        cdata: false,
        render_nil: false
      )

      instance.add(mapping, :element, 'val2')

      mapping = Shale::Mapping::Descriptor::Xml.new(
        name: 'bar',
        attribute: nil,
        methods: { from: :met_from_alt, to: :met_to_alt },
        group: 'group2',
        namespace: Shale::Mapping::Descriptor::XmlNamespace.new('http://foo.com', 'foo'),
        cdata: false,
        render_nil: false
      )

      instance.add(mapping, :attribute, 'val3')

      result = instance.each.to_a

      expect(result.length).to eq(2)

      expect(result[0].method_from).to eq(:met_from)
      expect(result[0].method_to).to eq(:met_to)
      expect(result[0].dict).to eq(
        content: 'val1',
        elements: { 'foo' => 'val2' },
        attributes: { 'bar' => 'val3' }
      )

      expect(result[1].method_from).to eq(:met_from_alt)
      expect(result[1].method_to).to eq(:met_to_alt)
      expect(result[1].dict).to eq(
        content: 'val1',
        elements: { 'http://foo.com:foo' => 'val2' },
        attributes: { 'http://foo.com:bar' => 'val3' }
      )
    end
  end
end
