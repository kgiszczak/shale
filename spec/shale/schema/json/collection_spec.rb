# frozen_string_literal: true

require 'shale/schema/json/boolean'
require 'shale/schema/json/collection'

RSpec.describe Shale::Schema::JSON::Collection do
  let(:type) { Shale::Schema::JSON::Boolean.new('foo') }

  describe '#name' do
    it 'returns name of the wrapped type' do
      expect(described_class.new(type).name).to eq(type.name)
    end
  end

  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { 'type' => 'array', 'items' => { 'type' => 'boolean' } }
      expect(described_class.new(type).as_json).to eq(expected)
    end
  end
end
