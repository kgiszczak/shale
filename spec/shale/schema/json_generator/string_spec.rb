# frozen_string_literal: true

require 'shale/schema/json_generator/string'
require 'shale/mapping/descriptor/dict'

RSpec.describe Shale::Schema::JSONGenerator::String do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expect(described_class.new('foo').as_type).to eq({ 'type' => 'string' })
    end

    context 'when mapping is passed with a schema' do
      it 'can include string keywords from JSON schema' do
        mapping = Shale::Mapping::Descriptor::Dict.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: nil,
          schema: {
            format: 'email',
            min_length: 5,
            max_length: 10,
            pattern: 'foo-bar',
          }
        )
        expected = {
          'type' => 'string',
          'format' => 'email',
          'minLength' => 5,
          'maxLength' => 10,
          'pattern' => 'foo-bar',
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
          schema: { min_length: 1 }
        )
        expected = { 'type' => 'string', 'minLength' => 1 }
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
        expected = { 'type' => 'string' }
        expect(described_class.new('foo', mapping: mapping).as_type).to eq(expected)
      end
    end
  end
end
