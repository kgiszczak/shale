# frozen_string_literal: true

require 'shale/schema/json_generator/boolean'

RSpec.describe Shale::Schema::JSONGenerator::Boolean do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { 'type' => 'boolean' }
      expect(described_class.new('foo').as_type).to eq(expected)
    end
  end
end
