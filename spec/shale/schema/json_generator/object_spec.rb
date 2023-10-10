# frozen_string_literal: true

require 'shale/schema/json_generator/boolean'
require 'shale/schema/json_generator/object'
require 'shale/mapping/descriptor/dict'

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

      expect(described_class.new('foo', types).as_type).to eq(expected)
    end

    context 'with mappings' do
      it 'puts properties with `required` on their schema into the "required" array' do
        non_required_mapping = Shale::Mapping::Descriptor::Dict.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false
        )

        required_mapping = Shale::Mapping::Descriptor::Dict.new(
          name: 'bar',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false,
          schema: { required: true }
        )

        types_with_required =
          [
            Shale::Schema::JSONGenerator::Boolean.new('foo', mapping: non_required_mapping),
            Shale::Schema::JSONGenerator::Boolean.new('bar', mapping: required_mapping),
          ]

        expected = {
          'type' => 'object',
          'properties' => {
            'foo' => { 'type' => %w[boolean null] },
            'bar' => { 'type' => 'boolean' },
          },
          'required' => ['bar'],
        }

        expect(described_class.new('foo', types_with_required).as_type).to eq(expected)
      end
    end
  end
end
