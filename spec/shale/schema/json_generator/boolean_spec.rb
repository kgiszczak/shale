# frozen_string_literal: true

require 'shale/schema/json_generator/boolean'

RSpec.describe Shale::Schema::JSONGenerator::Boolean do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expect(described_class.new('foo').as_type).to eq({ 'type' => 'boolean' })
    end

    context 'when schema is passed' do
      it 'can include string keywords from JSON schema' do
        schema = {
          description: 'Attribute description',
        }
        expected = {
          'type' => 'boolean',
          'description' => 'Attribute description',
        }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end

      it 'can use a subset of schema keywords' do
        schema = {}
        expected = { 'type' => 'boolean' }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end

      it 'will not use keywords for other types' do
        schema = { unique_items: true }
        expected = { 'type' => 'boolean' }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end
    end
  end
end
