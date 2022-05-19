# frozen_string_literal: true

require 'shale/schema/json_generator/ref'

RSpec.describe Shale::Schema::JSONGenerator::Ref do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { '$ref' => '#/$defs/bar' }
      expect(described_class.new('foo', 'bar').as_type).to eq(expected)
    end
  end
end
