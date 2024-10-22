# frozen_string_literal: true

require 'shale/schema/json_generator/string'

RSpec.describe Shale::Schema::JSONGenerator::String do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expect(described_class.new('foo').as_type).to eq({ 'type' => 'string' })
    end

    context 'when schema is passed' do
      it 'can include string keywords from JSON schema' do
        schema = {
          format: 'email',
          min_length: 5,
          max_length: 10,
          pattern: 'foo-bar',
          description: 'Attribute description',
        }
        expected = {
          'type' => 'string',
          'format' => 'email',
          'minLength' => 5,
          'maxLength' => 10,
          'pattern' => 'foo-bar',
          'description' => 'Attribute description',
        }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end

      it 'can use a subset of schema keywords' do
        schema = { min_length: 1 }
        expected = { 'type' => 'string', 'minLength' => 1 }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end

      it 'will not use keywords for other types' do
        schema = { unique_items: true }
        expected = { 'type' => 'string' }
        expect(described_class.new('foo', schema: schema).as_type).to eq(expected)
      end
    end
  end
end
