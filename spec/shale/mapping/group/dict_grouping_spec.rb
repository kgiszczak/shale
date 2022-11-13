# frozen_string_literal: true

require 'shale/mapping/group/dict_grouping'
require 'shale/mapping/descriptor/dict'

RSpec.describe Shale::Mapping::Group::DictGrouping do
  describe '#add' do
    it 'adds a group for a mapping' do
      instance = described_class.new

      mapping = Shale::Mapping::Descriptor::Dict.new(
        name: 'foo',
        attribute: nil,
        receiver: nil,
        methods: { from: :met_from, to: :met_to },
        group: 'group1',
        render_nil: false
      )

      instance.add(mapping, 'val1')

      mapping = Shale::Mapping::Descriptor::Dict.new(
        name: 'bar',
        attribute: nil,
        receiver: nil,
        methods: { from: :met_from, to: :met_to },
        group: 'group1',
        render_nil: false
      )

      instance.add(mapping, 'val2')

      mapping = Shale::Mapping::Descriptor::Dict.new(
        name: 'baz',
        attribute: nil,
        receiver: nil,
        methods: { from: :met_from_alt, to: :met_to_alt },
        group: 'group2',
        render_nil: false
      )

      instance.add(mapping, 'val3')

      result = instance.each.to_a

      expect(result.length).to eq(2)

      expect(result[0].method_from).to eq(:met_from)
      expect(result[0].method_to).to eq(:met_to)
      expect(result[0].dict).to eq({ 'foo' => 'val1', 'bar' => 'val2' })

      expect(result[1].method_from).to eq(:met_from_alt)
      expect(result[1].method_to).to eq(:met_to_alt)
      expect(result[1].dict).to eq({ 'baz' => 'val3' })
    end
  end

  describe '#each' do
    it 'iterates over groups' do
      instance = described_class.new

      mapping = Shale::Mapping::Descriptor::Dict.new(
        name: 'foo',
        attribute: nil,
        receiver: nil,
        methods: { from: :met_from, to: :met_to },
        group: 'group1',
        render_nil: false
      )

      instance.add(mapping, 'val1')

      mapping = Shale::Mapping::Descriptor::Dict.new(
        name: 'bar',
        attribute: nil,
        receiver: nil,
        methods: { from: :met_from, to: :met_to },
        group: 'group1',
        render_nil: false
      )

      instance.add(mapping, 'val2')

      mapping = Shale::Mapping::Descriptor::Dict.new(
        name: 'baz',
        attribute: nil,
        receiver: nil,
        methods: { from: :met_from_alt, to: :met_to_alt },
        group: 'group2',
        render_nil: false
      )

      instance.add(mapping, 'val3')

      methods_from = []
      methods_to = []
      dicts = []

      instance.each do |group|
        methods_from << group.method_from
        methods_to << group.method_to
        dicts << group.dict
      end

      expect(methods_from).to eq(%i[met_from met_from_alt])
      expect(methods_to).to eq(%i[met_to met_to_alt])
      expect(dicts).to eq([{ 'foo' => 'val1', 'bar' => 'val2' }, { 'baz' => 'val3' }])
    end
  end
end
