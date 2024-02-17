# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__Types # rubocop:disable Naming/ClassAndModuleCamelCase
  class Child < Shale::Mapper
    attribute :type_boolean, Shale::Type::Boolean
    attribute :type_date, Shale::Type::Date
    attribute :type_float, Shale::Type::Float
    attribute :type_integer, Shale::Type::Integer
    attribute :type_string, Shale::Type::String
    attribute :type_time, Shale::Type::Time
    attribute :type_value, Shale::Type::Value
  end

  class Root < Shale::Mapper
    attribute :type_boolean, Shale::Type::Boolean
    attribute :type_date, Shale::Type::Date
    attribute :type_float, Shale::Type::Float
    attribute :type_integer, Shale::Type::Integer
    attribute :type_string, Shale::Type::String
    attribute :type_time, Shale::Type::Time
    attribute :type_value, Shale::Type::Value
    attribute :child, Child

    attribute :type_boolean_collection, Shale::Type::Boolean, collection: true
    attribute :type_date_collection, Shale::Type::Date, collection: true
    attribute :type_float_collection, Shale::Type::Float, collection: true
    attribute :type_integer_collection, Shale::Type::Integer, collection: true
    attribute :type_string_collection, Shale::Type::String, collection: true
    attribute :type_time_collection, Shale::Type::Time, collection: true
    attribute :type_value_collection, Shale::Type::Value, collection: true
    attribute :child_collection, Child, collection: true

    csv do
      map 'type_boolean', to: :type_boolean
      map 'type_date', to: :type_date
      map 'type_float', to: :type_float
      map 'type_integer', to: :type_integer
      map 'type_string', to: :type_string
      map 'type_time', to: :type_time
      map 'type_value', to: :type_value
    end
  end
end

RSpec.describe Shale::Type::Complex do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
    Shale.yaml_adapter = YAML
    Shale.toml_adapter = Tomlib
    Shale.csv_adapter = Shale::Adapter::CSV
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  let(:mapper) { ComplexSpec__Types::Root }

  context 'with types' do
    context 'with hash mapping' do
      let(:hash) do
        {
          'type_boolean' => true,
          'type_date' => Date.new(2022, 1, 1),
          'type_float' => 1.1,
          'type_integer' => 1,
          'type_string' => 'foo',
          'type_time' => Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
          'type_value' => 'foo',
          'child' => {
            'type_boolean' => true,
            'type_date' => Date.new(2022, 1, 1),
            'type_float' => 1.1,
            'type_integer' => 1,
            'type_string' => 'foo',
            'type_time' => Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            'type_value' => 'foo',
          },
          'type_boolean_collection' => [true, false],
          'type_date_collection' => [Date.new(2022, 1, 1), Date.new(2022, 1, 2)],
          'type_float_collection' => [1.1, 2.2],
          'type_integer_collection' => [1, 2],
          'type_string_collection' => %w[foo bar],
          'type_time_collection' => [
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            Time.new(2021, 1, 2, 10, 10, 10, '+01:00'),
          ],
          'type_value_collection' => ['foo', 1, true],
          'child_collection' => [
            {
              'type_boolean' => true,
              'type_date' => Date.new(2022, 1, 1),
              'type_float' => 1.1,
              'type_integer' => 1,
              'type_string' => 'foo',
              'type_time' => Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
              'type_value' => 'foo',
            },
            {
              'type_boolean' => true,
              'type_date' => Date.new(2022, 1, 1),
              'type_float' => 1.1,
              'type_integer' => 1,
              'type_string' => 'foo',
              'type_time' => Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
              'type_value' => 'foo',
            },
          ],
        }
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = mapper.from_hash(hash)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')

          expect(instance.type_boolean_collection).to eq([true, false])
          expect(instance.type_date_collection).to eq([
            Date.new(2022, 1, 1),
            Date.new(2022, 1, 2),
          ])
          expect(instance.type_float_collection).to eq([1.1, 2.2])
          expect(instance.type_integer_collection).to eq([1, 2])
          expect(instance.type_string_collection).to eq(%w[foo bar])
          expect(instance.type_time_collection).to eq([
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            Time.new(2021, 1, 2, 10, 10, 10, '+01:00'),
          ])
          expect(instance.type_value_collection).to eq(['foo', 1, true])

          expect(instance.child_collection[0].type_boolean).to eq(true)
          expect(instance.child_collection[0].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[0].type_float).to eq(1.1)
          expect(instance.child_collection[0].type_integer).to eq(1)
          expect(instance.child_collection[0].type_string).to eq('foo')
          expect(instance.child_collection[0].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[0].type_value).to eq('foo')

          expect(instance.child_collection[1].type_boolean).to eq(true)
          expect(instance.child_collection[1].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[1].type_float).to eq(1.1)
          expect(instance.child_collection[1].type_integer).to eq(1)
          expect(instance.child_collection[1].type_string).to eq('foo')
          expect(instance.child_collection[1].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[1].type_value).to eq('foo')
        end
      end

      describe '.to_hash' do
        it 'converts objects to hash' do
          instance = mapper.from_hash(hash)

          result = instance.to_hash
          expect(result).to eq(hash)
        end
      end
    end

    context 'with JSON mapping' do
      let(:json) do
        <<~DOC
          {
            "type_boolean": true,
            "type_date": "2022-01-01",
            "type_float": 1.1,
            "type_integer": 1,
            "type_string": "foo",
            "type_time": "2021-01-01T10:10:10+01:00",
            "type_value": "foo",
            "child": {
              "type_boolean": true,
              "type_date": "2022-01-01",
              "type_float": 1.1,
              "type_integer": 1,
              "type_string": "foo",
              "type_time": "2021-01-01T10:10:10+01:00",
              "type_value": "foo"
            },
            "type_boolean_collection": [
              true,
              false
            ],
            "type_date_collection": [
              "2022-01-01",
              "2022-01-02"
            ],
            "type_float_collection": [
              1.1,
              2.2
            ],
            "type_integer_collection": [
              1,
              2
            ],
            "type_string_collection": [
              "foo",
              "bar"
            ],
            "type_time_collection": [
              "2021-01-01T10:10:10+01:00",
              "2021-01-02T10:10:10+01:00"
            ],
            "type_value_collection": [
              "foo",
              1,
              true
            ],
            "child_collection": [
              {
                "type_boolean": true,
                "type_date": "2022-01-01",
                "type_float": 1.1,
                "type_integer": 1,
                "type_string": "foo",
                "type_time": "2021-01-01T10:10:10+01:00",
                "type_value": "foo"
              },
              {
                "type_boolean": true,
                "type_date": "2022-01-01",
                "type_float": 1.1,
                "type_integer": 1,
                "type_string": "foo",
                "type_time": "2021-01-01T10:10:10+01:00",
                "type_value": "foo"
              }
            ]
          }
        DOC
      end

      describe '.from_json' do
        it 'maps JSON to object' do
          instance = mapper.from_json(json)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')

          expect(instance.type_boolean_collection).to eq([true, false])
          expect(instance.type_date_collection).to eq([
            Date.new(2022, 1, 1),
            Date.new(2022, 1, 2),
          ])
          expect(instance.type_float_collection).to eq([1.1, 2.2])
          expect(instance.type_integer_collection).to eq([1, 2])
          expect(instance.type_string_collection).to eq(%w[foo bar])
          expect(instance.type_time_collection).to eq([
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            Time.new(2021, 1, 2, 10, 10, 10, '+01:00'),
          ])
          expect(instance.type_value_collection).to eq(['foo', 1, true])

          expect(instance.child_collection[0].type_boolean).to eq(true)
          expect(instance.child_collection[0].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[0].type_float).to eq(1.1)
          expect(instance.child_collection[0].type_integer).to eq(1)
          expect(instance.child_collection[0].type_string).to eq('foo')
          expect(instance.child_collection[0].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[0].type_value).to eq('foo')

          expect(instance.child_collection[1].type_boolean).to eq(true)
          expect(instance.child_collection[1].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[1].type_float).to eq(1.1)
          expect(instance.child_collection[1].type_integer).to eq(1)
          expect(instance.child_collection[1].type_string).to eq('foo')
          expect(instance.child_collection[1].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[1].type_value).to eq('foo')
        end
      end

      describe '.to_json' do
        it 'converts objects to JSON' do
          instance = mapper.from_json(json)

          result = instance.to_json(pretty: true)
          expect(result).to eq(json.gsub(/\n\z/, ''))
        end
      end
    end

    context 'with YAML mapping' do
      let(:yaml) do
        <<~DOC
          ---
          type_boolean: true
          type_date: '2022-01-01'
          type_float: 1.1
          type_integer: 1
          type_string: foo
          type_time: '2021-01-01T10:10:10+01:00'
          type_value: foo
          child:
            type_boolean: true
            type_date: '2022-01-01'
            type_float: 1.1
            type_integer: 1
            type_string: foo
            type_time: '2021-01-01T10:10:10+01:00'
            type_value: foo
          type_boolean_collection:
          - true
          - false
          type_date_collection:
          - '2022-01-01'
          - '2022-01-02'
          type_float_collection:
          - 1.1
          - 2.2
          type_integer_collection:
          - 1
          - 2
          type_string_collection:
          - foo
          - bar
          type_time_collection:
          - '2021-01-01T10:10:10+01:00'
          - '2021-01-02T10:10:10+01:00'
          type_value_collection:
          - foo
          - 1
          - true
          child_collection:
          - type_boolean: true
            type_date: '2022-01-01'
            type_float: 1.1
            type_integer: 1
            type_string: foo
            type_time: '2021-01-01T10:10:10+01:00'
            type_value: foo
          - type_boolean: true
            type_date: '2022-01-01'
            type_float: 1.1
            type_integer: 1
            type_string: foo
            type_time: '2021-01-01T10:10:10+01:00'
            type_value: foo
        DOC
      end

      describe '.from_yaml' do
        it 'maps YAML to object' do
          instance = mapper.from_yaml(yaml)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')

          expect(instance.type_boolean_collection).to eq([true, false])
          expect(instance.type_date_collection).to eq([
            Date.new(2022, 1, 1),
            Date.new(2022, 1, 2),
          ])
          expect(instance.type_float_collection).to eq([1.1, 2.2])
          expect(instance.type_integer_collection).to eq([1, 2])
          expect(instance.type_string_collection).to eq(%w[foo bar])
          expect(instance.type_time_collection).to eq([
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            Time.new(2021, 1, 2, 10, 10, 10, '+01:00'),
          ])
          expect(instance.type_value_collection).to eq(['foo', 1, true])

          expect(instance.child_collection[0].type_boolean).to eq(true)
          expect(instance.child_collection[0].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[0].type_float).to eq(1.1)
          expect(instance.child_collection[0].type_integer).to eq(1)
          expect(instance.child_collection[0].type_string).to eq('foo')
          expect(instance.child_collection[0].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[0].type_value).to eq('foo')

          expect(instance.child_collection[1].type_boolean).to eq(true)
          expect(instance.child_collection[1].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[1].type_float).to eq(1.1)
          expect(instance.child_collection[1].type_integer).to eq(1)
          expect(instance.child_collection[1].type_string).to eq('foo')
          expect(instance.child_collection[1].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[1].type_value).to eq('foo')
        end
      end

      describe '.to_yaml' do
        it 'converts objects to YAML' do
          instance = mapper.from_yaml(yaml)

          result = instance.to_yaml
          expect(result).to eq(yaml)
        end
      end
    end

    context 'with TOML mapping' do
      let(:toml) do
        <<~DOC
          type_boolean = true
          type_date = 2022-01-01
          type_float = 1.1
          type_integer = 1
          type_string = "foo"
          type_time = 2021-01-01T10:10:10.000+01:00
          type_value = "foo"
          type_boolean_collection = [ true, false ]
          type_date_collection = [ 2022-01-01, 2022-01-02 ]
          type_float_collection = [ 1.1, 2.2 ]
          type_integer_collection = [ 1, 2 ]
          type_string_collection = [ "foo", "bar" ]
          type_time_collection = [ 2021-01-01T10:10:10.000+01:00, 2021-01-02T10:10:10.000+01:00 ]
          type_value_collection = [ "foo", 1, true ]

          [child]
          type_boolean = true
          type_date = 2022-01-01
          type_float = 1.1
          type_integer = 1
          type_string = "foo"
          type_time = 2021-01-01T10:10:10.000+01:00
          type_value = "foo"

          [[child_collection]]
          type_boolean = true
          type_date = 2022-01-01
          type_float = 1.1
          type_integer = 1
          type_string = "foo"
          type_time = 2021-01-01T10:10:10.000+01:00
          type_value = "foo"

          [[child_collection]]
          type_boolean = true
          type_date = 2022-01-01
          type_float = 1.1
          type_integer = 1
          type_string = "foo"
          type_time = 2021-01-01T10:10:10.000+01:00
          type_value = "foo"
        DOC
      end

      describe '.from_toml' do
        it 'maps TOML to object' do
          instance = mapper.from_toml(toml)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')

          expect(instance.type_boolean_collection).to eq([true, false])
          expect(instance.type_date_collection).to eq([
            Date.new(2022, 1, 1),
            Date.new(2022, 1, 2),
          ])
          expect(instance.type_float_collection).to eq([1.1, 2.2])
          expect(instance.type_integer_collection).to eq([1, 2])
          expect(instance.type_string_collection).to eq(%w[foo bar])
          expect(instance.type_time_collection).to eq([
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            Time.new(2021, 1, 2, 10, 10, 10, '+01:00'),
          ])
          expect(instance.type_value_collection).to eq(['foo', 1, true])

          expect(instance.child_collection[0].type_boolean).to eq(true)
          expect(instance.child_collection[0].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[0].type_float).to eq(1.1)
          expect(instance.child_collection[0].type_integer).to eq(1)
          expect(instance.child_collection[0].type_string).to eq('foo')
          expect(instance.child_collection[0].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[0].type_value).to eq('foo')

          expect(instance.child_collection[1].type_boolean).to eq(true)
          expect(instance.child_collection[1].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[1].type_float).to eq(1.1)
          expect(instance.child_collection[1].type_integer).to eq(1)
          expect(instance.child_collection[1].type_string).to eq('foo')
          expect(instance.child_collection[1].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[1].type_value).to eq('foo')
        end
      end

      describe '.to_toml' do
        it 'converts objects to TOML' do
          instance = mapper.from_toml(toml)

          result = instance.to_toml
          expect(result).to eq(toml)
        end
      end
    end

    context 'with CSV mapping' do
      let(:csv) do
        <<~DOC
          true,2022-01-01,1.1,1,foo,2021-01-01T10:10:10+01:00,foo
        DOC
      end

      describe '.from_csv' do
        it 'maps CSV to object' do
          instance = mapper.from_csv(csv)[0]

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')
        end
      end

      describe '.to_csv' do
        it 'converts objects to CSV' do
          instance = mapper.from_csv(csv)

          result = mapper.to_csv(instance)
          expect(result).to eq(csv)
        end
      end
    end

    context 'with XML mapping' do
      let(:xml) do
        <<~DOC
          <root>
            <type_boolean>true</type_boolean>
            <type_date>2022-01-01</type_date>
            <type_float>1.1</type_float>
            <type_integer>1</type_integer>
            <type_string>foo</type_string>
            <type_time>2021-01-01T10:10:10+01:00</type_time>
            <type_value>foo</type_value>
            <child>
              <type_boolean>true</type_boolean>
              <type_date>2022-01-01</type_date>
              <type_float>1.1</type_float>
              <type_integer>1</type_integer>
              <type_string>foo</type_string>
              <type_time>2021-01-01T10:10:10+01:00</type_time>
              <type_value>foo</type_value>
            </child>
            <type_boolean_collection>true</type_boolean_collection>
            <type_boolean_collection>false</type_boolean_collection>
            <type_date_collection>2022-01-01</type_date_collection>
            <type_date_collection>2022-01-02</type_date_collection>
            <type_float_collection>1.1</type_float_collection>
            <type_float_collection>2.2</type_float_collection>
            <type_integer_collection>1</type_integer_collection>
            <type_integer_collection>2</type_integer_collection>
            <type_string_collection>foo</type_string_collection>
            <type_string_collection>bar</type_string_collection>
            <type_time_collection>2021-01-01T10:10:10+01:00</type_time_collection>
            <type_time_collection>2021-01-02T10:10:10+01:00</type_time_collection>
            <type_value_collection>foo</type_value_collection>
            <type_value_collection>1</type_value_collection>
            <type_value_collection>true</type_value_collection>
            <child_collection>
              <type_boolean>true</type_boolean>
              <type_date>2022-01-01</type_date>
              <type_float>1.1</type_float>
              <type_integer>1</type_integer>
              <type_string>foo</type_string>
              <type_time>2021-01-01T10:10:10+01:00</type_time>
              <type_value>foo</type_value>
            </child_collection>
            <child_collection>
              <type_boolean>true</type_boolean>
              <type_date>2022-01-01</type_date>
              <type_float>1.1</type_float>
              <type_integer>1</type_integer>
              <type_string>foo</type_string>
              <type_time>2021-01-01T10:10:10+01:00</type_time>
              <type_value>foo</type_value>
            </child_collection>
          </root>
        DOC
      end

      describe '.from_xml' do
        it 'maps XML to object' do
          instance = mapper.from_xml(xml)

          expect(instance.type_boolean).to eq(true)
          expect(instance.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.type_float).to eq(1.1)
          expect(instance.type_integer).to eq(1)
          expect(instance.type_string).to eq('foo')
          expect(instance.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.type_value).to eq('foo')

          expect(instance.child.type_boolean).to eq(true)
          expect(instance.child.type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child.type_float).to eq(1.1)
          expect(instance.child.type_integer).to eq(1)
          expect(instance.child.type_string).to eq('foo')
          expect(instance.child.type_time).to eq(Time.new(2021, 1, 1, 10, 10, 10, '+01:00'))
          expect(instance.child.type_value).to eq('foo')

          expect(instance.type_boolean_collection).to eq([true, false])
          expect(instance.type_date_collection).to eq([
            Date.new(2022, 1, 1),
            Date.new(2022, 1, 2),
          ])
          expect(instance.type_float_collection).to eq([1.1, 2.2])
          expect(instance.type_integer_collection).to eq([1, 2])
          expect(instance.type_string_collection).to eq(%w[foo bar])
          expect(instance.type_time_collection).to eq([
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00'),
            Time.new(2021, 1, 2, 10, 10, 10, '+01:00'),
          ])
          expect(instance.type_value_collection).to eq(%w[foo 1 true])

          expect(instance.child_collection[0].type_boolean).to eq(true)
          expect(instance.child_collection[0].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[0].type_float).to eq(1.1)
          expect(instance.child_collection[0].type_integer).to eq(1)
          expect(instance.child_collection[0].type_string).to eq('foo')
          expect(instance.child_collection[0].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[0].type_value).to eq('foo')

          expect(instance.child_collection[1].type_boolean).to eq(true)
          expect(instance.child_collection[1].type_date).to eq(Date.new(2022, 1, 1))
          expect(instance.child_collection[1].type_float).to eq(1.1)
          expect(instance.child_collection[1].type_integer).to eq(1)
          expect(instance.child_collection[1].type_string).to eq('foo')
          expect(instance.child_collection[1].type_time).to eq(
            Time.new(2021, 1, 1, 10, 10, 10, '+01:00')
          )
          expect(instance.child_collection[1].type_value).to eq('foo')
        end
      end

      describe '.to_xml' do
        it 'converts objects to XML' do
          instance = mapper.from_xml(xml)

          result = instance.to_xml(pretty: true)
          expect(result).to eq(xml.gsub(/\n\z/, ''))
        end
      end
    end
  end
end
