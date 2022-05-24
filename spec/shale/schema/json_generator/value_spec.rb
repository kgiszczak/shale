# frozen_string_literal: true

require 'shale/schema/json_generator/value'

RSpec.describe Shale::Schema::JSONGenerator::Value do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = {
        'type' => %w[boolean integer number object string],
      }

      expect(described_class.new('foo').as_type).to eq(expected)
    end
  end
end
