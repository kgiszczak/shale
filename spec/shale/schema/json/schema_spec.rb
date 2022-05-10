# frozen_string_literal: true

require 'shale/schema/json/object'
require 'shale/schema/json/schema'

RSpec.describe Shale::Schema::JSON::Schema do
  describe '#as_json' do
    context 'when id and description are not empty' do
      it 'returns JSON Schema fragment as Hash' do
        schema = described_class.new([], id: 'foo', description: 'bar')
        expected = {
          '$schema' => 'https://json-schema.org/draft/2020-12/schema',
          '$id' => 'foo',
          'description' => 'bar',
        }

        expect(schema.as_json).to eq(expected)
      end
    end

    context 'when types are not empty' do
      it 'returns JSON Schema fragment as Hash' do
        types = [
          Shale::Schema::JSON::Object.new('Foo', []),
          Shale::Schema::JSON::Object.new('Bar', []),
        ]

        schema = described_class.new(types)

        expected = {
          '$schema' => 'https://json-schema.org/draft/2020-12/schema',
          '$ref' => '#/$defs/Foo',
          '$defs' => {
            'Bar' => { 'properties' => {}, 'type' => %w[object null] },
            'Foo' => { 'properties' => {}, 'type' => 'object' },
          },
        }

        expect(schema.as_json).to eq(expected)
      end
    end
  end
end
