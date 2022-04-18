# frozen_string_literal: true

require 'shale/schema/json/boolean'
require 'shale/schema/json/object'

RSpec.describe Shale::Schema::JSON::Object do
  let(:types) do
    [Shale::Schema::JSON::Boolean.new('bar')]
  end

  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = {
        'type' => 'object',
        'properties' => {
          'bar' => { 'type' => %w[boolean null] },
        },
      }

      expect(described_class.new('foo', types).as_type).to eq(expected)
    end
  end
end
