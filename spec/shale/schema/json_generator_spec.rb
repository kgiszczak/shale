# frozen_string_literal: true

require 'shale/adapter/json'
require 'shale/schema/json_generator'
require 'shale/error'

module ShaleSchemaJSONGeneratorTesting
  class BranchOne < Shale::Mapper
    attribute :one, Shale::Type::String, nullable: true

    json do
      map 'One', to: :one
    end
  end

  class BranchTwo < Shale::Mapper
    attribute :two, Shale::Type::String, nullable: true

    json do
      map 'Two', to: :two
    end
  end

  class Root < Shale::Mapper
    attribute :boolean, Shale::Type::Boolean, nullable: true
    attribute :date, Shale::Type::Date, nullable: true
    attribute :float, Shale::Type::Float, nullable: true
    attribute :integer, Shale::Type::Integer, nullable: true
    attribute :string, Shale::Type::String, nullable: true
    attribute :time, Shale::Type::Time, nullable: true
    attribute :value, Shale::Type::Value, nullable: true

    attribute :boolean_default, Shale::Type::Boolean, default: -> { true }, nullable: true
    attribute :date_default, Shale::Type::Date, default: -> { Date.new(2021, 1, 1) }, nullable: true
    attribute :float_default, Shale::Type::Float, default: -> { 1.0 }, nullable: true
    attribute :integer_default, Shale::Type::Integer, default: -> { 1 }, nullable: true
    attribute :string_default, Shale::Type::String, default: -> { 'string' }, nullable: true
    attribute :time_default,
      Shale::Type::Time,
      default: -> { Time.new(2021, 1, 1, 10, 10, 10, '+01:00') }, nullable: true
    attribute :value_default, Shale::Type::Value, default: -> { 'value' }, nullable: true

    attribute :boolean_collection, Shale::Type::Boolean, collection: true, nullable: true
    attribute :date_collection, Shale::Type::Date, collection: true, nullable: true
    attribute :float_collection, Shale::Type::Float, collection: true, nullable: true
    attribute :integer_collection, Shale::Type::Integer, collection: true, nullable: true
    attribute :string_collection, Shale::Type::String, collection: true, nullable: true
    attribute :time_collection, Shale::Type::Time, collection: true, nullable: true
    attribute :value_collection, Shale::Type::Value, collection: true, nullable: true

    attribute :branch_one, BranchOne
    attribute :branch_two, BranchTwo
    attribute :circular_dependency, Root
  end

  class CircularDependencyB < Shale::Mapper
  end

  class CircularDependencyA < Shale::Mapper
    attribute :circular_dependency_b, CircularDependencyB
  end

  class CircularDependencyB
    attribute :circular_dependency_a, CircularDependencyA
  end

  class Address
    attr_accessor :street, :city
  end

  class Person
    attr_accessor :first_name, :last_name, :address
  end

  class AddressMapper < Shale::Mapper
    model Address
    attribute :street, Shale::Type::String, nullable: true
    attribute :city, Shale::Type::String, nullable: true
  end

  class PersonMapper < Shale::Mapper
    model Person
    attribute :first_name, Shale::Type::String, nullable: true
    attribute :last_name, Shale::Type::String, nullable: true
    attribute :address, AddressMapper
  end
end

RSpec.describe Shale::Schema::JSONGenerator do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
  end

  let(:expected_schema_hash) do
    {
      '$schema' => 'https://json-schema.org/draft/2020-12/schema',
      '$id' => 'My ID',
      'title' => 'My title',
      'description' => 'My description',
      '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_Root',
      '$defs' => {
        'ShaleSchemaJSONGeneratorTesting_BranchOne' => {
          'type' => %w[object null],
          'properties' => {
            'One' => {
              'type' => %w[string null],
            },
          },
        },
        'ShaleSchemaJSONGeneratorTesting_BranchTwo' => {
          'type' => %w[object null],
          'properties' => {
            'Two' => {
              'type' => %w[string null],
            },
          },
        },
        'ShaleSchemaJSONGeneratorTesting_Root' => {
          'type' => 'object',
          'properties' => {
            'boolean' => {
              'type' => %w[boolean null],
            },
            'date' => {
              'type' => %w[string null],
              'format' => 'date',
            },
            'float' => {
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
              'type' => %w[boolean integer number object string null],
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
            'float_default' => {
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
              'type' => %w[boolean integer number object string null],
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
            'float_collection' => {
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
              'items' => { 'type' => %w[boolean integer number object string] },
            },
            'branch_one' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_BranchOne',
            },
            'branch_two' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_BranchTwo',
            },
            'circular_dependency' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_Root',
            },
          },
        },
      },
    }
  end

  let(:expected_circular_schema_hash) do
    {
      '$schema' => 'https://json-schema.org/draft/2020-12/schema',
      '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_CircularDependencyA',
      '$defs' => {
        'ShaleSchemaJSONGeneratorTesting_CircularDependencyA' => {
          'type' => 'object',
          'properties' => {
            'circular_dependency_b' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_CircularDependencyB',
            },
          },
        },
        'ShaleSchemaJSONGeneratorTesting_CircularDependencyB' => {
          'type' => %w[object null],
          'properties' => {
            'circular_dependency_a' => {
              '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_CircularDependencyA',
            },
          },
        },
      },
    }
  end

  describe 'json_types' do
    it 'registers new type' do
      described_class.register_json_type('foo', 'bar')
      expect(described_class.get_json_type('foo')).to eq('bar')
    end
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
        schema = described_class.new.as_schema(ShaleSchemaJSONGeneratorTesting::Root)
        expect(schema['id']).to eq(nil)
      end
    end

    context 'without title' do
      it 'generates schema without title' do
        schema = described_class.new.as_schema(ShaleSchemaJSONGeneratorTesting::Root)
        expect(schema['title']).to eq(nil)
      end
    end

    context 'without description' do
      it 'generates schema without description' do
        schema = described_class.new.as_schema(ShaleSchemaJSONGeneratorTesting::Root)
        expect(schema['description']).to eq(nil)
      end
    end

    context 'with correct arguments' do
      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          ShaleSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description'
        )

        expect(schema).to eq(expected_schema_hash)
      end
    end

    context 'with classes depending on each other' do
      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          ShaleSchemaJSONGeneratorTesting::CircularDependencyA
        )

        expect(schema).to eq(expected_circular_schema_hash)
      end
    end

    context 'with custom models' do
      let(:expected_schema) do
        {
          '$schema' => 'https://json-schema.org/draft/2020-12/schema',
          '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_Person',
          '$defs' => {
            'ShaleSchemaJSONGeneratorTesting_Address' => {
              'type' => %w[object null],
              'properties' => {
                'street' => { 'type' => %w[string null] },
                'city' => { 'type' => %w[string null] },
              },
            },
            'ShaleSchemaJSONGeneratorTesting_Person' => {
              'type' => 'object',
              'properties' => {
                'first_name' => { 'type' => %w[string null] },
                'last_name' => { 'type' => %w[string null] },
                'address' => { '$ref' => '#/$defs/ShaleSchemaJSONGeneratorTesting_Address' },
              },
            },
          },
        }
      end

      it 'generates JSON schema' do
        schema = described_class.new.as_schema(
          ShaleSchemaJSONGeneratorTesting::PersonMapper
        )

        expect(schema).to eq(expected_schema)
      end
    end
  end

  describe '#to_schema' do
    context 'with pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          ShaleSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description',
          pretty: true
        )

        expect(schema).to eq(Shale.json_adapter.dump(expected_schema_hash, pretty: true))
      end
    end

    context 'without pretty param' do
      it 'genrates JSON document' do
        schema = described_class.new.to_schema(
          ShaleSchemaJSONGeneratorTesting::Root,
          id: 'My ID',
          title: 'My title',
          description: 'My description'
        )

        expect(schema).to eq(Shale.json_adapter.dump(expected_schema_hash))
      end
    end
  end
end
