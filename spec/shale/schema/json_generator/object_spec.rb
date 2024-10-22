# frozen_string_literal: true

require 'shale/schema/json_generator/boolean'
require 'shale/schema/json_generator/object'

RSpec.describe Shale::Schema::JSONGenerator::Object do
  let(:types) do
    [Shale::Schema::JSONGenerator::Boolean.new('bar')]
  end

  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = {
        'type' => 'object',
        'properties' => {
          'bar' => { 'type' => %w[boolean null] },
        },
      }

      expect(described_class.new('foo', types, {}).as_type).to eq(expected)
    end

    context 'with schema' do
      it 'puts properties with `required` on their schema into the "required" array' do
        required_schema = { required: true }

        types_with_required =
          [
            Shale::Schema::JSONGenerator::Boolean.new('foo', schema: nil),
            Shale::Schema::JSONGenerator::Boolean.new('bar', schema: required_schema),
          ]

        expected = {
          'type' => 'object',
          'properties' => {
            'foo' => { 'type' => %w[boolean null] },
            'bar' => { 'type' => 'boolean' },
          },
          'required' => ['bar'],
        }

        expect(described_class.new('foo', types_with_required, {}).as_type).to eq(expected)
      end
    end

    context 'with root properties' do
      it 'puts properties on the root object' do
        expected = {
          'type' => 'object',
          'minProperties' => 1,
          'maxProperties' => 5,
          'dependentRequired' => { 'foo' => ['bar'] },
          'properties' => {
            'bar' => { 'type' => %w[boolean null] },
          },
          'description' => 'Attribute description',
          'additionalProperties' => false,
        }

        root = {
          min_properties: 1,
          max_properties: 5,
          dependent_required: { 'foo' => ['bar'] },
          description: 'Attribute description',
          additional_properties: false,
        }

        expect(described_class.new('foo', types, root).as_type).to eq(expected)
      end
    end
  end
end
