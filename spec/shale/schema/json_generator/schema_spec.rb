# frozen_string_literal: true

require 'shale/schema/json_generator/object'
require 'shale/schema/json_generator/schema'

RSpec.describe Shale::Schema::JSONGenerator::Schema do
  describe '#as_json' do
    context 'when id, title and description are not empty' do
      it 'returns JSON Schema fragment as Hash' do
        schema = described_class.new([], id: 'foo', title: 'bar', description: 'baz')
        expected = {
          '$schema' => 'https://json-schema.org/draft/2020-12/schema',
          '$id' => 'foo',
          'title' => 'bar',
          'description' => 'baz',
        }

        expect(schema.as_json).to eq(expected)
      end
    end

    context 'when types are not empty' do
      it 'returns JSON Schema fragment as Hash' do
        types = [
          Shale::Schema::JSONGenerator::Object.new('Foo', [], {}),
          Shale::Schema::JSONGenerator::Object.new('Bar', [], {}),
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
