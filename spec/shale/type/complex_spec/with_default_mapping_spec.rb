# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'shale/adapter/tomlib'

module ComplexSpec__DefaultMapping # rubocop:disable Naming/ClassAndModuleCamelCase
  class Child < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String, collection: true
  end

  class Parent < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String, collection: true
    attribute :child, Child
  end

  class ParentCsv < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String
  end
end

RSpec.describe Shale::Type::Complex do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
    Shale.yaml_adapter = YAML
    Shale.toml_adapter = Shale::Adapter::Tomlib
    Shale.csv_adapter = Shale::Adapter::CSV
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  let(:mapper) { ComplexSpec__DefaultMapping::Parent }
  let(:child_class) { ComplexSpec__DefaultMapping::Child }

  context 'with default mapping' do
    context 'with hash mapping' do
      let(:hash) do
        {
          'one' => 'foo',
          'two' => %w[foo bar baz],
          'child' => {
            'one' => 'foo',
            'two' => %w[foo bar baz],
          },
        }
      end

      let(:hash_collection) do
        [hash, hash]
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = mapper.from_hash(hash)

          expect(instance.one).to eq('foo')
          expect(instance.two).to eq(%w[foo bar baz])
          expect(instance.child.one).to eq('foo')
          expect(instance.child.two).to eq(%w[foo bar baz])
        end

        it 'maps collection to object' do
          instance = mapper.from_hash(hash_collection)

          2.times do |i|
            expect(instance[i].one).to eq('foo')
            expect(instance[i].two).to eq(%w[foo bar baz])
            expect(instance[i].child.one).to eq('foo')
            expect(instance[i].child.two).to eq(%w[foo bar baz])
          end
        end
      end

      describe '.to_hash' do
        it 'converts objects to hash' do
          instance = mapper.new(
            one: 'foo',
            two: %w[foo bar baz],
            child: child_class.new(one: 'foo', two: %w[foo bar baz])
          )

          expect(instance.to_hash).to eq(hash)
        end

        it 'converts array to hash' do
          instance = mapper.new(
            one: 'foo',
            two: %w[foo bar baz],
            child: child_class.new(one: 'foo', two: %w[foo bar baz])
          )

          expect(mapper.to_hash([instance, instance])).to eq(hash_collection)
        end
      end
    end

    context 'with json mapping' do
      let(:json) do
        <<~DOC.gsub(/\n\z/, '')
          {
            "one": "foo",
            "two": [
              "foo",
              "bar",
              "baz"
            ],
            "child": {
              "one": "foo",
              "two": [
                "foo",
                "bar",
                "baz"
              ]
            }
          }
        DOC
      end

      let(:json_collection) do
        <<~DOC.gsub(/\n\z/, '')
          [
            {
              "one": "foo",
              "two": [
                "foo",
                "bar",
                "baz"
              ],
              "child": {
                "one": "foo",
                "two": [
                  "foo",
                  "bar",
                  "baz"
                ]
              }
            },
            {
              "one": "foo",
              "two": [
                "foo",
                "bar",
                "baz"
              ],
              "child": {
                "one": "foo",
                "two": [
                  "foo",
                  "bar",
                  "baz"
                ]
              }
            }
          ]
        DOC
      end

      describe '.from_json' do
        it 'maps json to object' do
          instance = mapper.from_json(json)

          expect(instance.one).to eq('foo')
          expect(instance.two).to eq(%w[foo bar baz])
          expect(instance.child.one).to eq('foo')
          expect(instance.child.two).to eq(%w[foo bar baz])
        end

        it 'maps collection to object' do
          instance = mapper.from_json(json_collection)

          2.times do |i|
            expect(instance[i].one).to eq('foo')
            expect(instance[i].two).to eq(%w[foo bar baz])
            expect(instance[i].child.one).to eq('foo')
            expect(instance[i].child.two).to eq(%w[foo bar baz])
          end
        end

        context 'with params' do
          let(:json) do
            '{ "one": NaN }'
          end

          it 'maps json to object' do
            instance = mapper.from_json(json, allow_nan: true)
            expect(instance.one).to eq('NaN')
          end
        end
      end

      describe '.to_json' do
        context 'without params' do
          it 'converts objects to json' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_json).to eq(json.gsub(/\s+/, ''))
          end

          it 'converts array to json' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(mapper.to_json([instance, instance])).to eq(json_collection.gsub(/\s+/, ''))
          end
        end

        context 'with pretty: true' do
          it 'converts objects to json' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_json(pretty: true)).to eq(json)
          end

          it 'converts array to json' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(mapper.to_json([instance, instance], pretty: true)).to eq(json_collection)
          end
        end

        context 'with other params' do
          it 'converts objects to json' do
            instance = mapper.new(one: 'foo', two: nil)
            expect(instance.to_json(allow_nan: true)).to eq('{"one":"foo"}')
          end
        end
      end
    end

    context 'with yaml mapping' do
      let(:yaml) do
        <<~DOC
          ---
          one: foo
          two:
          - foo
          - bar
          - baz
          child:
            one: foo
            two:
            - foo
            - bar
            - baz
        DOC
      end

      let(:yaml_collection) do
        <<~DOC
          ---
          - one: foo
            two:
            - foo
            - bar
            - baz
            child:
              one: foo
              two:
              - foo
              - bar
              - baz
          - one: foo
            two:
            - foo
            - bar
            - baz
            child:
              one: foo
              two:
              - foo
              - bar
              - baz
        DOC
      end

      describe '.from_yaml' do
        it 'maps yaml to object' do
          instance = mapper.from_yaml(yaml)

          expect(instance.one).to eq('foo')
          expect(instance.two).to eq(%w[foo bar baz])
          expect(instance.child.one).to eq('foo')
          expect(instance.child.two).to eq(%w[foo bar baz])
        end

        it 'maps collection to object' do
          instance = mapper.from_yaml(yaml_collection)

          2.times do |i|
            expect(instance[i].one).to eq('foo')
            expect(instance[i].two).to eq(%w[foo bar baz])
            expect(instance[i].child.one).to eq('foo')
            expect(instance[i].child.two).to eq(%w[foo bar baz])
          end
        end

        it 'accepts extra options' do
          instance = mapper.from_yaml(yaml, fallback: false)
          expect(instance.one).to eq('foo')
        end
      end

      describe '.to_yaml' do
        it 'converts objects to yaml' do
          instance = mapper.new(
            one: 'foo',
            two: %w[foo bar baz],
            child: child_class.new(one: 'foo', two: %w[foo bar baz])
          )

          expect(instance.to_yaml).to eq(yaml)
        end

        it 'converts array to yaml' do
          instance = mapper.new(
            one: 'foo',
            two: %w[foo bar baz],
            child: child_class.new(one: 'foo', two: %w[foo bar baz])
          )

          expect(mapper.to_yaml([instance, instance])).to eq(yaml_collection)
        end

        it 'accepts extra options' do
          instance = mapper.new(one: 'foo', two: nil)
          expect(instance.to_yaml(indentation: 2)).to eq("---\none: foo\n")
        end
      end
    end

    context 'with toml mapping' do
      let(:toml) do
        <<~DOC
          one = "foo"
          two = [ "foo", "bar", "baz" ]

          [child]
          one = "foo"
          two = [ "foo", "bar", "baz" ]
        DOC
      end

      describe '.from_toml' do
        context 'when adapter is not set' do
          it 'raises an error' do
            Shale.toml_adapter = nil

            expect do
              mapper.from_toml(toml)
            end.to raise_error(Shale::AdapterError, /TOML Adapter is not set/)
          end
        end

        context 'when adapter is set' do
          it 'maps toml to object' do
            instance = mapper.from_toml(toml)

            expect(instance.one).to eq('foo')
            expect(instance.two).to eq(%w[foo bar baz])
            expect(instance.child.one).to eq('foo')
            expect(instance.child.two).to eq(%w[foo bar baz])
          end

          it 'accepts extra options' do
            instance = mapper.from_toml(toml, foo: :bar)
            expect(instance.one).to eq('foo')
          end
        end
      end

      describe '.to_toml' do
        context 'when adapter is not set' do
          it 'raises an error' do
            Shale.toml_adapter = nil

            expect do
              mapper.new.to_toml
            end.to raise_error(Shale::AdapterError, /TOML Adapter is not set/)
          end
        end

        context 'when adapter is set' do
          it 'converts objects to toml' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_toml).to eq(toml)
          end

          it 'accepts extra options' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_toml(indent: false)).to eq(toml)
          end
        end
      end
    end

    context 'with csv mapping' do
      let(:mapper) { ComplexSpec__DefaultMapping::ParentCsv }

      describe '.from_csv' do
        context 'when adapter is not set' do
          let(:csv) do
            <<~DOC
              foo,bar
            DOC
          end

          it 'raises an error' do
            Shale.csv_adapter = nil

            expect do
              mapper.from_csv(csv)
            end.to raise_error(Shale::AdapterError, /CSV Adapter is not set/)
          end
        end

        context 'without params' do
          let(:csv) do
            <<~DOC
              foo,bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              foo,bar
              foo,bar
            DOC
          end

          it 'maps csv to object' do
            instance = mapper.from_csv(csv)

            expect(instance[0].one).to eq('foo')
            expect(instance[0].two).to eq('bar')
          end

          it 'maps collection to object' do
            instance = mapper.from_csv(csv_collection)

            2.times do |i|
              expect(instance[i].one).to eq('foo')
              expect(instance[i].two).to eq('bar')
            end
          end
        end

        context 'with headers: true' do
          let(:csv) do
            <<~DOC
              one,two
              foo,bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              one,two
              foo,bar
              foo,bar
            DOC
          end

          it 'maps csv to object' do
            instance = mapper.from_csv(csv, headers: true)

            expect(instance[0].one).to eq('foo')
            expect(instance[0].two).to eq('bar')
          end

          it 'maps collection to object' do
            instance = mapper.from_csv(csv_collection, headers: true)

            2.times do |i|
              expect(instance[i].one).to eq('foo')
              expect(instance[i].two).to eq('bar')
            end
          end
        end

        context 'with headers: true and other options' do
          let(:csv) do
            <<~DOC
              one|two
              foo|bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              one|two
              foo|bar
              foo|bar
            DOC
          end

          it 'maps csv to object' do
            instance = mapper.from_csv(csv, headers: true, col_sep: '|')

            expect(instance[0].one).to eq('foo')
            expect(instance[0].two).to eq('bar')
          end

          it 'maps collection to object' do
            instance = mapper.from_csv(csv_collection, headers: true, col_sep: '|')

            2.times do |i|
              expect(instance[i].one).to eq('foo')
              expect(instance[i].two).to eq('bar')
            end
          end
        end
      end

      describe '.to_csv' do
        context 'when adapter is not set' do
          let(:csv) do
            <<~DOC
              foo,bar
            DOC
          end

          it 'raises an error' do
            Shale.csv_adapter = nil

            expect do
              mapper.to_csv(csv)
            end.to raise_error(Shale::AdapterError, /CSV Adapter is not set/)
          end
        end

        context 'without params' do
          let(:csv) do
            <<~DOC
              foo,bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              foo,bar
              foo,bar
            DOC
          end

          it 'converts objects to csv' do
            instance = mapper.new(one: 'foo', two: 'bar')
            expect(instance.to_csv).to eq(csv)
          end

          it 'converts array to csv' do
            instance = mapper.new(one: 'foo', two: 'bar')
            expect(mapper.to_csv([instance, instance])).to eq(csv_collection)
          end
        end

        context 'with headers: true' do
          let(:csv) do
            <<~DOC
              one,two
              foo,bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              one,two
              foo,bar
              foo,bar
            DOC
          end

          it 'converts objects to csv' do
            instance = mapper.new(one: 'foo', two: 'bar')
            expect(instance.to_csv(headers: true)).to eq(csv)
          end

          it 'converts array to csv' do
            instance = mapper.new(one: 'foo', two: 'bar')
            result = mapper.to_csv([instance, instance], headers: true)
            expect(result).to eq(csv_collection)
          end
        end

        context 'with headers: true and other options' do
          let(:csv) do
            <<~DOC
              one|two
              foo|bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              one|two
              foo|bar
              foo|bar
            DOC
          end

          it 'converts objects to csv' do
            instance = mapper.new(one: 'foo', two: 'bar')
            expect(instance.to_csv(headers: true, col_sep: '|')).to eq(csv)
          end

          it 'converts array to csv' do
            instance = mapper.new(one: 'foo', two: 'bar')
            result = mapper.to_csv([instance, instance], headers: true, col_sep: '|')
            expect(result).to eq(csv_collection)
          end
        end
      end
    end

    context 'with xml mapping' do
      describe '.from_xml' do
        let(:xml) do
          <<~DOC.gsub(/\n\z/, '')
            <parent>
              <one>foo</one>
              <two>foo</two>
              <two>bar</two>
              <two>baz</two>
              <child>
                <one>foo</one>
                <two>foo</two>
                <two>bar</two>
                <two>baz</two>
              </child>
            </parent>
          DOC
        end

        context 'when adapter is not set' do
          it 'raises an error' do
            Shale.xml_adapter = nil

            expect do
              mapper.from_xml(xml)
            end.to raise_error(Shale::AdapterError, /XML Adapter is not set/)
          end
        end

        context 'when adapter is set' do
          it 'maps xml to object' do
            instance = mapper.from_xml(xml)

            expect(instance.one).to eq('foo')
            expect(instance.two).to eq(%w[foo bar baz])
            expect(instance.child.one).to eq('foo')
            expect(instance.child.two).to eq(%w[foo bar baz])
          end
        end
      end

      describe '.to_xml' do
        context 'when adapter is not set' do
          it 'raises an error' do
            Shale.xml_adapter = nil

            expect do
              mapper.new.to_xml
            end.to raise_error(Shale::AdapterError, /XML Adapter is not set/)
          end
        end

        context 'without params' do
          let(:xml) do
            <<~DOC.gsub(/\n|\s/, '')
              <parent>
                <one>foo</one>
                <two>foo</two>
                <two>bar</two>
                <two>baz</two>
                <child>
                  <one>foo</one>
                  <two>foo</two>
                  <two>bar</two>
                  <two>baz</two>
                </child>
              </parent>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_xml).to eq(xml)
          end
        end

        context 'with pretty: true' do
          let(:xml) do
            <<~DOC.gsub(/\n\z/, '')
              <parent>
                <one>foo</one>
                <two>foo</two>
                <two>bar</two>
                <two>baz</two>
                <child>
                  <one>foo</one>
                  <two>foo</two>
                  <two>bar</two>
                  <two>baz</two>
                </child>
              </parent>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_xml(pretty: true)).to eq(xml)
          end
        end

        context 'with declaration: true' do
          let(:xml) do
            <<~DOC.gsub(/\n|\s{2,}/, '')
              <?xml version="1.0"?>
              <parent>
                <one>foo</one>
                <two>foo</two>
                <two>bar</two>
                <two>baz</two>
                <child>
                  <one>foo</one>
                  <two>foo</two>
                  <two>bar</two>
                  <two>baz</two>
                </child>
              </parent>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_xml(declaration: true)).to eq(xml)
          end
        end

        context 'with declaration: true and encoding: true' do
          let(:xml) do
            <<~DOC.gsub(/\n|\s{2,}/, '')
              <?xml version="1.0" encoding="UTF-8"?>
              <parent>
                <one>foo</one>
                <two>foo</two>
                <two>bar</two>
                <two>baz</two>
                <child>
                  <one>foo</one>
                  <two>foo</two>
                  <two>bar</two>
                  <two>baz</two>
                </child>
              </parent>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_xml(declaration: true, encoding: true)).to eq(xml)
          end
        end

        context 'when declaration is a string and encoding: is a string' do
          let(:xml) do
            <<~DOC.gsub(/\n|\s{2,}/, '')
              <?xml version="1.1" encoding="ASCII"?>
              <parent>
                <one>foo</one>
                <two>foo</two>
                <two>bar</two>
                <two>baz</two>
                <child>
                  <one>foo</one>
                  <two>foo</two>
                  <two>bar</two>
                  <two>baz</two>
                </child>
              </parent>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_xml(declaration: '1.1', encoding: 'ASCII')).to eq(xml)
          end
        end

        context 'with pretty: true and declaration: true' do
          let(:xml) do
            <<~DOC.gsub(/\n\z/, '')
              <?xml version="1.0"?>
              <parent>
                <one>foo</one>
                <two>foo</two>
                <two>bar</two>
                <two>baz</two>
                <child>
                  <one>foo</one>
                  <two>foo</two>
                  <two>bar</two>
                  <two>baz</two>
                </child>
              </parent>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'foo',
              two: %w[foo bar baz],
              child: child_class.new(one: 'foo', two: %w[foo bar baz])
            )

            expect(instance.to_xml(pretty: true, declaration: true)).to eq(xml)
          end
        end
      end
    end
  end
end
