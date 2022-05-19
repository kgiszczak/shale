# frozen_string_literal: true

require 'shale/schema/json_generator/integer'

RSpec.describe Shale::Schema::JSONGenerator::Integer do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { 'type' => 'integer' }
      expect(described_class.new('foo').as_type).to eq(expected)
    end
  end
end
