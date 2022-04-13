# frozen_string_literal: true

require 'shale/schema/json'
require 'shale/error'

module ShaleSchemaJSONTesting
  class BranchOne < Shale::Mapper
    attribute :one, Shale::Type::String

    json do
      map 'One', to: :one
    end
  end

  class BranchTwo < Shale::Mapper
    attribute :two, Shale::Type::String

    json do
      map 'Two', to: :two
    end
  end

  class Root < Shale::Mapper
    attribute :boolean, Shale::Type::Boolean
    attribute :date, Shale::Type::Date
    attribute :floeat, Shale::Type::Float
    attribute :integer, Shale::Type::Integer
    attribute :string, Shale::Type::String
    attribute :time, Shale::Type::Time
    attribute :value, Shale::Type::Value

    attribute :boolean_default, Shale::Type::Boolean, default: -> { true }
    attribute :date_default, Shale::Type::Date, default: -> { Date.new(2021, 1, 1) }
    attribute :floeat_default, Shale::Type::Float, default: -> { 1.0 }
    attribute :integer_default, Shale::Type::Integer, default: -> { 1 }
    attribute :string_default, Shale::Type::String, default: -> { 'string' }
    attribute :time_default,
      Shale::Type::Time,
      default: -> { Time.new(2021, 1, 1, 10, 10, 10, '+01:00') }
    attribute :value_default, Shale::Type::Value, default: -> { 'value' }

    attribute :boolean_collection, Shale::Type::Boolean, collection: true
    attribute :date_collection, Shale::Type::Date, collection: true
    attribute :floeat_collection, Shale::Type::Float, collection: true
    attribute :integer_collection, Shale::Type::Integer, collection: true
    attribute :string_collection, Shale::Type::String, collection: true
    attribute :time_collection, Shale::Type::Time, collection: true
    attribute :value_collection, Shale::Type::Value, collection: true

    attribute :branch_one, BranchOne
    attribute :branch_two, BranchTwo
  end
end

RSpec.describe Shale::Schema::JSON do
  let(:expected_schema_hash) do
    {
      '$schema' => 'https://json-schema.org/draft/2020-12/schema',
      'id' => 'My ID',
      'description' => 'My description',
      '$ref' => '#/$defs/ShaleSchemaJSONTesting_Root',
      '$defs' => {
        'ShaleSchemaJSONTesting_BranchOne' => {
          'type' => %w[object null],
          'properties' => {
            'One' => {
              'type' => %w[string null],
            },
          },
        },
        'ShaleSchemaJSONTesting_BranchTwo' => {
          'type' => %w[object null],
          'properties' => {
            'Two' => {
              'type' => %w[string null],
            },
          },
        },
        'ShaleSchemaJSONTesting_Root' => {
          'type' => 'object',
          'properties' => {
            'boolean' => {
              'type' => %w[boolean null],
            },
            'date' => {
              'type' => %w[string null],
              'format' => 'date',
            },
            'floeat' => {
              'type' => %w[number null],
            },
            'integer' => {
              'type' => %w[integer null],
            },
            'string' => {
              'type' => %w[string null],
            },
            'time' => {
              'type' => %w[string null],
              'format' => 'date-time',
            },
            'value' => {
              'type' => %w[string null],
            },
            'boolean_default' => {
              'type' => %w[boolean null],
              'default' => true,
            },
            'date_default' => {
              'type' => %w[string null],
              'format' => 'date',
              'default' => '2021-01-01',
            },
            'floeat_default' => {
              'type' => %w[number null],
              'default' => 1.0,
            },
            'integer_default' => {
              'type' => %w[integer null],
              'default' => 1,
            },
            'string_default' => {
              'type' => %w[string null],
              'default' => 'string',
            },
            'time_default' => {
              'type' => %w[string null],
              'format' => 'date-time',
              'default' => '2021-01-01T10:10:10+01:00',
            },
            'value_default' => {
              'type' => %w[string null],
              'default' => 'value',
            },
            'boolean_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'boolean' },
            },
            'date_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string', 'format' => 'date' },
            },
            'floeat_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'number' },
            },
            'integer_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'integer' },
            },
            'string_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string' },
            },
            'time_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string', 'format' => 'date-time' },
            },
            'value_collection' => {
              'type' => 'array',
              'items' => { 'type' => 'string' },
            },
            'branch_one' => {
              '$ref' => '#/$defs/ShaleSchemaJSONTesting_BranchOne',
            },
            'branch_two' => {
              '$ref' => '#/$defs/ShaleSchemaJSONTesting_BranchTwo',
            },
          },
        },
      },
    }
  end

  describe '#as_schema' do
    context 'when incorrect argument' do
      it 'raises error' do
        expect do
          described_class.new.as_schema(String)
        end.to raise_error(Shale::NotAShaleMapperError)
      end
    end

    context 'without id' do
      it 'generates schema without id' do
        schema = described_class.new.as_schema(ShaleSchemaJSONTesting::Root)
        expect(schema['id']).to eq(nil)
      end
    end

    context 'without description' do
      it 'generates schema without description' do
        schema = described_class.new.as_schema(ShaleSchemaJSONTesting::Root)
        expect(schema['description']).to eq(nil)
      end
    end

    context 'without correct arguments' do
      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          ShaleSchemaJSONTesting::Root,
          id: 'My ID',
          description: 'My description'
        )

        expect(schema).to eq(expected_schema_hash)
      end
    end
  end

  describe '#to_schema' do
    context 'with pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          ShaleSchemaJSONTesting::Root,
          id: 'My ID',
          description: 'My description',
          pretty: true
        )

        expect(schema).to eq(Shale.json_adapter.dump(expected_schema_hash, :pretty))
      end
    end

    context 'without pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          ShaleSchemaJSONTesting::Root,
          id: 'My ID',
          description: 'My description'
        )

        expect(schema).to eq(Shale.json_adapter.dump(expected_schema_hash))
      end
    end
  end
end
