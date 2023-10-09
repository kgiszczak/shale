# frozen_string_literal: true

require 'shale/schema/json_generator/float'

RSpec.describe Shale::Schema::JSONGenerator::Float do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expected = { 'type' => 'number' }
      expect(described_class.new('foo').as_type).to eq(expected)
    end

    context 'when mapping is passed with a schema' do
      it 'can include numeric keywords from JSON schema' do
        mapping = Shale::Mapping::Descriptor::Dict.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: nil,
          schema: {
            exclusive_minimum: 0,
            exclusive_maximum: 500,
            minimum: 0,
            maximum: 100,
            multiple_of: 4,
          }
        )
        expected = {
          'type' => 'number',
          'exclusiveMinimum' => 0,
          'exclusiveMaximum' => 500,
          'minimum' => 0,
          'maximum' => 100,
          'multipleOf' => 4,
        }
        expect(described_class.new('foo', mapping: mapping).as_type).to eq(expected)
      end

      it 'can use a subset of schema keywords' do
        mapping = Shale::Mapping::Descriptor::Dict.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: nil,
          schema: { minimum: 1 }
        )
        expected = { 'type' => 'number', 'minimum' => 1 }
        expect(described_class.new('foo', mapping: mapping).as_type).to eq(expected)
      end

      it 'will not use keywords for other types' do
        mapping = Shale::Mapping::Descriptor::Dict.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: nil,
          schema: { unique_items: true }
        )
        expected = { 'type' => 'number' }
        expect(described_class.new('foo', mapping: mapping).as_type).to eq(expected)
      end
    end
  end
end
