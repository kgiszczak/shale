# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__CustomMapping # rubocop:disable Naming/ClassAndModuleCamelCase
  class Child < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String, collection: true

    hsh do
      map 'One', to: :one
      map 'Two', to: :two
    end

    json do
      map 'One', to: :one
      map 'Two', to: :two
    end

    yaml do
      map 'One', to: :one
      map 'Two', to: :two
    end

    toml do
      map 'One', to: :one
      map 'Two', to: :two
    end
  end

  class Parent < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String, collection: true
    attribute :child, Child

    hsh do
      map 'One', to: :one
      map 'Two', to: :two
      map 'Child', to: :child
    end

    json do
      map 'One', to: :one
      map 'Two', to: :two
      map 'Child', to: :child
    end

    yaml do
      map 'One', to: :one
      map 'Two', to: :two
      map 'Child', to: :child
    end

    toml do
      map 'One', to: :one
      map 'Two', to: :two
      map 'Child', to: :child
    end
  end

  class ParentCsv < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String

    csv do
      map 'One', to: :one
      map 'Two', to: :two
    end
  end

  class ChildXml < Shale::Mapper
    attribute :content, Shale::Type::String
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String

    xml do
      map_content to: :content
      map_attribute 'One', to: :one
      map_element 'Two', to: :two
    end
  end

  class ParentXml < Shale::Mapper
    attribute :content, Shale::Type::String
    attribute :one, Shale::Type::String
    attribute :one_collection, Shale::Type::String, collection: true
    attribute :two, Shale::Type::String
    attribute :two_collection, Shale::Type::String, collection: true
    attribute :child, ChildXml

    xml do
      root 'Parent'
      map_content to: :content
      map_attribute 'One', to: :one
      map_attribute 'OneCollection', to: :one_collection
      map_element 'Two', to: :two
      map_element 'TwoCollection', to: :two_collection
      map_element 'Child', to: :child
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

  let(:mapper) { ComplexSpec__CustomMapping::Parent }
  let(:child_class) { ComplexSpec__CustomMapping::Child }

  context 'with custom mapping' do
    context 'with hash mapping' do
      let(:hash) do
        {
          'One' => 'foo',
          'Two' => %w[foo bar baz],
          'Child' => {
            'One' => 'foo',
            'Two' => %w[foo bar baz],
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
            "One": "foo",
            "Two": [
              "foo",
              "bar",
              "baz"
            ],
            "Child": {
              "One": "foo",
              "Two": [
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
              "One": "foo",
              "Two": [
                "foo",
                "bar",
                "baz"
              ],
              "Child": {
                "One": "foo",
                "Two": [
                  "foo",
                  "bar",
                  "baz"
                ]
              }
            },
            {
              "One": "foo",
              "Two": [
                "foo",
                "bar",
                "baz"
              ],
              "Child": {
                "One": "foo",
                "Two": [
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
      end

      describe '.to_json' do
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
    end

    context 'with yaml mapping' do
      let(:yaml) do
        <<~DOC
          ---
          One: foo
          Two:
          - foo
          - bar
          - baz
          Child:
            One: foo
            Two:
            - foo
            - bar
            - baz
        DOC
      end

      let(:yaml_collection) do
        <<~DOC
          ---
          - One: foo
            Two:
            - foo
            - bar
            - baz
            Child:
              One: foo
              Two:
              - foo
              - bar
              - baz
          - One: foo
            Two:
            - foo
            - bar
            - baz
            Child:
              One: foo
              Two:
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
      end
    end

    context 'with toml mapping' do
      let(:toml) do
        <<~DOC
          One = "foo"
          Two = [ "foo", "bar", "baz" ]

          [Child]
          One = "foo"
          Two = [ "foo", "bar", "baz" ]
        DOC
      end

      describe '.from_toml' do
        it 'maps toml to object' do
          instance = mapper.from_toml(toml)

          expect(instance.one).to eq('foo')
          expect(instance.two).to eq(%w[foo bar baz])
          expect(instance.child.one).to eq('foo')
          expect(instance.child.two).to eq(%w[foo bar baz])
        end
      end

      describe '.to_toml' do
        it 'converts objects to toml' do
          instance = mapper.new(
            one: 'foo',
            two: %w[foo bar baz],
            child: child_class.new(one: 'foo', two: %w[foo bar baz])
          )

          expect(instance.to_toml).to eq(toml)
        end
      end
    end

    context 'with csv mapping' do
      let(:mapper) { ComplexSpec__CustomMapping::ParentCsv }

      describe '.from_csv' do
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
              One,Two
              foo,bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              One,Two
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
              One|Two
              foo|bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              One|Two
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
              One,Two
              foo,bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              One,Two
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
              One|Two
              foo|bar
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              One|Two
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
      let(:mapper) { ComplexSpec__CustomMapping::ParentXml }
      let(:child_class) { ComplexSpec__CustomMapping::ChildXml }

      describe '.from_xml' do
        let(:xml) do
          <<~DOC.gsub(/\n\z/, '')
            <Parent One="foo" OneCollection="foo">
              content
              <Two>foo</Two>
              <TwoCollection>foo</TwoCollection>
              <TwoCollection>bar</TwoCollection>
              <TwoCollection>baz</TwoCollection>
              <Child One="foo">
                content
                <Two>foo</Two>
              </Child>
            </Parent>
          DOC
        end

        it 'maps xml to object' do
          instance = mapper.from_xml(xml)

          expect(instance.one).to eq('foo')
          expect(instance.one_collection).to eq(['foo'])
          expect(instance.content).to eq("\n  content\n  ")
          expect(instance.two).to eq('foo')
          expect(instance.two_collection).to eq(%w[foo bar baz])
          expect(instance.child.one).to eq('foo')
          expect(instance.child.content).to eq("\n    content\n    ")
          expect(instance.child.two).to eq('foo')
        end
      end

      describe '.to_xml' do
        let(:xml) do
          <<~DOC.gsub(/\n|\s{2,}/, '')
            <Parent One="foo" OneCollection="[]">
              content
              <Two>foo</Two>
              <TwoCollection>foo</TwoCollection>
              <TwoCollection>bar</TwoCollection>
              <TwoCollection>baz</TwoCollection>
              <Child One="foo">
                content
                <Two>foo</Two>
              </Child>
            </Parent>
          DOC
        end

        it 'converts objects to xml' do
          instance = mapper.new(
            content: 'content',
            one: 'foo',
            two: 'foo',
            two_collection: %w[foo bar baz],
            child: child_class.new(content: 'content', one: 'foo', two: 'foo')
          )

          expect(instance.to_xml).to eq(xml)
        end
      end
    end
  end
end
