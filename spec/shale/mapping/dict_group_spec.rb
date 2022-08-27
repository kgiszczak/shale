# frozen_string_literal: true

require 'shale/mapping/dict_group'

RSpec.describe Shale::Mapping::DictGroup do
  describe '#name' do
    it 'returns name' do
      obj = described_class.new(:foo, :bar)
      expect(obj.name).to match('group_')
    end
  end

  describe '#map' do
    it 'created a mapping with group attribute' do
      obj = described_class.new(:foo, :bar)
      obj.map('foobar')

      expect(obj.keys.keys).to eq(['foobar'])
      expect(obj.keys['foobar'].name).to eq('foobar')
      expect(obj.keys['foobar'].attribute).to eq(nil)
      expect(obj.keys['foobar'].method_from).to eq(:foo)
      expect(obj.keys['foobar'].method_to).to eq(:bar)
      expect(obj.keys['foobar'].group).to eq(obj.name)
    end
  end
end
