# frozen_string_literal: true

require 'shale/schema/json_generator/float'

RSpec.describe Shale::Schema::JSONGenerator::Float do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { 'type' => 'number' }
      expect(described_class.new('foo').as_type).to eq(expected)
    end

    context 'when schema is passed' do
      it 'can include numeric keywords from JSON schema' do
        schema = {
          exclusive_minimum: 0,
          exclusive_maximum: 500,
          minimum: 0,
          maximum: 100,
          multiple_of: 4,
          description: 'Attribute description',
        }
        expected = {
          'type' => 'number',
          'exclusiveMinimum' => 0,
          'exclusiveMaximum' => 500,
          'minimum' => 0,
          'maximum' => 100,
          'multipleOf' => 4,
          'description' => 'Attribute description',
        }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end

      it 'can use a subset of schema keywords' do
        schema = { minimum: 1 }
        expected = { 'type' => 'number', 'minimum' => 1 }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end

      it 'will not use keywords for other types' do
        schema = { unique_items: true }
        expected = { 'type' => 'number' }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end
    end
  end
end
