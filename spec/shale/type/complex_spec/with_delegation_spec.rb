# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__Delegation # rubocop:disable Naming/ClassAndModuleCamelCase
  class Child < Shale::Mapper
    attribute :two, Shale::Type::String
    attribute :three, Shale::Type::String
  end

  class ParentNoChild < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :child, Child

    hsh do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
    end

    json do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
    end

    yaml do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
    end

    toml do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
    end

    csv do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
    end
  end

  class ChildXml < Shale::Mapper
    attribute :content, Shale::Type::String
    attribute :attr, Shale::Type::String
    attribute :attr_collection, Shale::Type::String, collection: true
    attribute :el, Shale::Type::String
    attribute :el_collection, Shale::Type::String, collection: true

    xml do
      root 'child_xml'

      map_attribute 'attr', to: :attr
      map_element 'el', to: :el
    end
  end

  class ParentNoChildXml < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :child, ChildXml

    xml do
      root 'parent_no_child_xml'

      map_content to: :content, receiver: :child
      map_attribute 'attr', to: :attr, receiver: :child
      map_attribute 'attr_collection', to: :attr_collection, receiver: :child
      map_element 'one', to: :one
      map_element 'el', to: :el, receiver: :child
      map_element 'el_collection', to: :el_collection, receiver: :child
    end
  end

  class ParentChild < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :child, Child

    hsh do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
      map 'child', to: :child
    end

    json do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
      map 'child', to: :child
    end

    yaml do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
      map 'child', to: :child
    end

    toml do
      map 'one', to: :one
      map 'two', to: :two, receiver: :child
      map 'three', to: :three, receiver: :child
      map 'child', to: :child
    end
  end

  class ParentChildXml < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :child, ChildXml

    xml do
      root 'parent_no_child_xml'

      map_attribute 'attr', to: :attr, receiver: :child
      map_element 'one', to: :one
      map_element 'el', to: :el, receiver: :child
      map_element 'child', to: :child
    end
  end

  class ChildDefault < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String, default: -> { 'foobar' }
  end

  class ParentDefault < Shale::Mapper
    attribute :child, ChildDefault

    hsh do
      map 'one', to: :one, receiver: :child
      map 'two', to: :two, receiver: :child
    end
  end

  class ErrorAttributeNotDefined < Shale::Mapper
    hsh do
      map 'one', to: :one, receiver: :child
    end
  end

  class ErrorNotAShaleMapper < Shale::Mapper
    attribute :child, Shale::Type::String

    hsh do
      map 'one', to: :one, receiver: :child
    end
  end

  class ErrorNotACollection < Shale::Mapper
    attribute :child, Child, collection: true

    hsh do
      map 'one', to: :one, receiver: :child
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

  context 'with delegation' do
    context 'with receiver not defined on a mapper' do
      let(:parent) { ComplexSpec__Delegation::ErrorAttributeNotDefined }

      it 'raises an exception' do
        msg = /attribute 'child' is not defined on #{parent.name}/

        expect do
          parent.from_hash({ 'one' => 'one' })
        end.to raise_error(Shale::AttributeNotDefinedError, msg)
      end
    end

    context 'when receiver is not a descendant of Shale::Mapper' do
      let(:parent) { ComplexSpec__Delegation::ErrorNotAShaleMapper }

      it 'raises an exception' do
        msg = /attribute 'child' is not a descendant of Shale::Mapper type/

        expect do
          parent.from_hash({ 'one' => 'one' })
        end.to raise_error(Shale::NotAShaleMapperError, msg)
      end
    end

    context 'when receiver is a collection' do
      let(:parent) { ComplexSpec__Delegation::ErrorNotACollection }

      it 'raises an exception' do
        msg = /attribute 'child' can't be a collection/

        expect do
          parent.from_hash({ 'one' => 'one' })
        end.to raise_error(Shale::NotAShaleMapperError, msg)
      end
    end

    context 'with default values' do
      let(:parent) { ComplexSpec__Delegation::ParentDefault }

      it 'initialize defaults' do
        instance = parent.from_hash({ 'one' => 'one' })

        expect(instance.child.one).to eq('one')
        expect(instance.child.two).to eq('foobar')
      end
    end

    context 'with hash mapping' do
      describe '.from_hash' do
        context 'with no child mapping' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:hash) do
            {
              'one' => 'one',
              'two' => 'two',
              'three' => 'three',
            }
          end

          it 'maps hash to object' do
            instance = parent.from_hash(hash)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('three')
          end
        end

        context 'with child mapping before delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChild }

          let(:hash) do
            {
              'one' => 'one',
              'child' => {
                'two' => 'foo',
                'three' => 'bar',
              },
              'two' => 'two',
            }
          end

          it 'maps hash to object' do
            instance = parent.from_hash(hash)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('bar')
          end
        end

        context 'with child mapping after delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChild }

          let(:hash) do
            {
              'one' => 'one',
              'two' => 'two',
              'child' => {
                'two' => 'foo',
                'three' => 'bar',
              },
            }
          end

          it 'maps hash to object' do
            instance = parent.from_hash(hash)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('bar')
          end
        end

        context 'with collection' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:hash) do
            [
              {
                'one' => 'one',
                'two' => 'two',
                'three' => 'three',
              },
              {
                'one' => 'one',
                'two' => 'two',
                'three' => 'three',
              },
            ]
          end

          it 'maps collection to array' do
            instance = parent.from_hash(hash)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].child.two).to eq('two')
              expect(instance[i].child.three).to eq('three')
            end
          end
        end
      end

      describe '.to_hash' do
        let(:parent) { ComplexSpec__Delegation::ParentNoChild }
        let(:child) { ComplexSpec__Delegation::Child }

        let(:hash) do
          {
            'one' => 'one',
            'two' => 'two',
            'three' => 'three',
          }
        end

        let(:hash_collection) do
          [
            {
              'one' => 'one',
              'two' => 'two',
              'three' => 'three',
            },
            {
              'one' => 'one',
              'two' => 'two',
              'three' => 'three',
            },
          ]
        end

        it 'converts objects to hash' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          expect(parent.to_hash(instance)).to eq(hash)
        end

        it 'converts objects to array' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          result = parent.to_hash([instance, instance])
          expect(result).to eq(hash_collection)
        end
      end
    end

    context 'with json mapping' do
      describe '.from_json' do
        context 'with no child mapping' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:json) do
            <<~DOC
              {
                "one": "one",
                "two": "two",
                "three": "three"
              }
            DOC
          end

          it 'maps json to object' do
            instance = parent.from_json(json)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('three')
          end
        end

        context 'with child mapping before delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChild }

          let(:json) do
            <<~DOC
              {
                "one": "one",
                "child": {
                  "two": "foo",
                  "three": "bar"
                },
                "two": "two"
              }
            DOC
          end

          it 'maps json to object' do
            instance = parent.from_json(json)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('bar')
          end
        end

        context 'with child mapping after delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChild }

          let(:json) do
            <<~DOC
              {
                "one": "one",
                "two": "two",
                "child": {
                  "two": "foo",
                  "three": "bar"
                }
              }
            DOC
          end

          it 'maps json to object' do
            instance = parent.from_json(json)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('bar')
          end
        end

        context 'with collection' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:json) do
            <<~DOC
              [
                {
                  "one": "one",
                  "two": "two",
                  "three": "three"
                },
                {
                  "one": "one",
                  "two": "two",
                  "three": "three"
                }
              ]
            DOC
          end

          it 'maps collection to array' do
            instance = parent.from_json(json)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].child.two).to eq('two')
              expect(instance[i].child.three).to eq('three')
            end
          end
        end
      end

      describe '.to_json' do
        let(:parent) { ComplexSpec__Delegation::ParentNoChild }
        let(:child) { ComplexSpec__Delegation::Child }

        let(:json) do
          <<~DOC.gsub(/\n\z/, '')
            {
              "one": "one",
              "two": "two",
              "three": "three"
            }
          DOC
        end

        let(:json_collection) do
          <<~DOC.gsub(/\n\z/, '')
            [
              {
                "one": "one",
                "two": "two",
                "three": "three"
              },
              {
                "one": "one",
                "two": "two",
                "three": "three"
              }
            ]
          DOC
        end

        it 'converts objects to json' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          expect(parent.to_json(instance, pretty: true)).to eq(json)
        end

        it 'converts objects to array' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          result = parent.to_json([instance, instance], pretty: true)
          expect(result).to eq(json_collection)
        end
      end
    end

    context 'with yaml mapping' do
      describe '.from_yaml' do
        context 'with no child mapping' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:yaml) do
            <<~DOC
              ---
              one: one
              two: two
              three: three
            DOC
          end

          it 'maps yaml to object' do
            instance = parent.from_yaml(yaml)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('three')
          end
        end

        context 'with child mapping before delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChild }

          let(:yaml) do
            <<~DOC
              ---
              one: one
              child:
                two: foo
                three: bar
              two: two
            DOC
          end

          it 'maps yaml to object' do
            instance = parent.from_yaml(yaml)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('bar')
          end
        end

        context 'with child mapping after delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChild }

          let(:yaml) do
            <<~DOC
              ---
              one: one
              two: two
              child:
                two: foo
                three: bar
            DOC
          end

          it 'maps yaml to object' do
            instance = parent.from_yaml(yaml)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('bar')
          end
        end

        context 'with collection' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:yaml) do
            <<~DOC
              ---
              - one: one
                two: two
                three: three
              - one: one
                two: two
                three: three
            DOC
          end

          it 'maps collection to array' do
            instance = parent.from_yaml(yaml)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].child.two).to eq('two')
              expect(instance[i].child.three).to eq('three')
            end
          end
        end
      end

      describe '.to_yaml' do
        let(:parent) { ComplexSpec__Delegation::ParentNoChild }
        let(:child) { ComplexSpec__Delegation::Child }

        let(:yaml) do
          <<~DOC
            ---
            one: one
            two: two
            three: three
          DOC
        end

        let(:yaml_collection) do
          <<~DOC
            ---
            - one: one
              two: two
              three: three
            - one: one
              two: two
              three: three
          DOC
        end

        it 'converts objects to yaml' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          expect(parent.to_yaml(instance)).to eq(yaml)
        end

        it 'converts objects to array' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          result = parent.to_yaml([instance, instance])
          expect(result).to eq(yaml_collection)
        end
      end
    end

    context 'with toml mapping' do
      describe '.from_toml' do
        context 'with no child mapping' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:toml) do
            <<~DOC
              one = "one"
              two = "two"
              three = "three"
            DOC
          end

          it 'maps toml to object' do
            instance = parent.from_toml(toml)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('three')
          end
        end

        context 'with child mapping after delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChild }

          let(:toml) do
            <<~DOC
              one = "one"
              two = "two"

              [child]
              two = "foo"
              three = "bar"
            DOC
          end

          it 'maps toml to object' do
            instance = parent.from_toml(toml)

            expect(instance.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('bar')
          end
        end
      end

      describe '.to_toml' do
        let(:parent) { ComplexSpec__Delegation::ParentNoChild }
        let(:child) { ComplexSpec__Delegation::Child }

        let(:toml) do
          <<~DOC
            one = "one"
            two = "two"
            three = "three"
          DOC
        end

        it 'converts objects to toml' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          expect(parent.to_toml(instance)).to eq(toml)
        end
      end
    end

    context 'with csv mapping' do
      describe '.from_csv' do
        context 'without collection' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:csv) do
            <<~DOC
              one,two,three
            DOC
          end

          it 'maps csv to object' do
            instance = parent.from_csv(csv)

            expect(instance[0].one).to eq('one')
            expect(instance[0].child.two).to eq('two')
            expect(instance[0].child.three).to eq('three')
          end
        end

        context 'with collection' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChild }

          let(:csv) do
            <<~DOC
              one,two,three
              one,two,three
            DOC
          end

          it 'maps collection to array' do
            instance = parent.from_csv(csv)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].child.two).to eq('two')
              expect(instance[i].child.three).to eq('three')
            end
          end
        end
      end

      describe '.to_csv' do
        let(:parent) { ComplexSpec__Delegation::ParentNoChild }
        let(:child) { ComplexSpec__Delegation::Child }

        let(:csv) do
          <<~DOC
            one,two,three
          DOC
        end

        let(:csv_collection) do
          <<~DOC
            one,two,three
            one,two,three
          DOC
        end

        it 'converts objects to csv' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          expect(parent.to_csv(instance)).to eq(csv)
        end

        it 'converts objects to array' do
          instance = parent.new(
            one: 'one',
            child: child.new(two: 'two', three: 'three')
          )

          result = parent.to_csv([instance, instance])
          expect(result).to eq(csv_collection)
        end
      end
    end

    context 'with xml mapping' do
      describe '.from_xml' do
        context 'with no child mapping' do
          let(:parent) { ComplexSpec__Delegation::ParentNoChildXml }

          let(:xml) do
            <<~DOC
              <parent_no_child_xml attr="attr" attr_collection="attr">
                content
                <one>one</one>
                <el>el</el>
                <el_collection>el1</el_collection>
                <el_collection>el2</el_collection>
              </parent_no_child_xml>
            DOC
          end

          it 'maps xml to object' do
            instance = parent.from_xml(xml)

            expect(instance.one).to eq('one')
            expect(instance.child.content).to eq("\n  content\n  ")
            expect(instance.child.attr).to eq('attr')
            expect(instance.child.attr_collection).to eq(['attr'])
            expect(instance.child.el).to eq('el')
            expect(instance.child.el_collection).to eq(%w[el1 el2])
          end
        end

        context 'with child mapping before delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChildXml }

          let(:xml) do
            <<~DOC
              <parent_no_child_xml>
                <one>one</one>
                <child attr="child attr">
                  <el>child el</el>
                </child>
                <el>parent el</el>
              </parent_no_child_xml>
            DOC
          end

          it 'maps xml to object' do
            instance = parent.from_xml(xml)

            expect(instance.one).to eq('one')
            expect(instance.child.attr).to eq('child attr')
            expect(instance.child.el).to eq('parent el')
          end
        end

        context 'with child mapping after delegates' do
          let(:parent) { ComplexSpec__Delegation::ParentChildXml }

          let(:xml) do
            <<~DOC
              <parent_no_child_xml>
                <one>one</one>
                <el>parent el</el>
                <child attr="child attr">
                  <el>child el</el>
                </child>
              </parent_no_child_xml>
            DOC
          end

          it 'maps xml to object' do
            instance = parent.from_xml(xml)

            expect(instance.one).to eq('one')
            expect(instance.child.attr).to eq('child attr')
            expect(instance.child.el).to eq('parent el')
          end
        end
      end

      describe '.to_xml' do
        let(:parent) { ComplexSpec__Delegation::ParentNoChildXml }
        let(:child) { ComplexSpec__Delegation::ChildXml }

        let(:xml) do
          <<~DOC.gsub(/\n\z/, '')
            <parent_no_child_xml attr="attr" attr_collection="[]">
              content
              <one>one</one>
              <el>el</el>
              <el_collection>el1</el_collection>
              <el_collection>el2</el_collection>
            </parent_no_child_xml>
          DOC
        end

        it 'converts objects to xml' do
          instance = parent.new(
            one: 'one',
            child: child.new(
              content: 'content',
              attr: 'attr',
              el: 'el',
              el_collection: %w[el1 el2]
            )
          )

          expect(parent.to_xml(instance, pretty: true)).to eq(xml)
        end
      end
    end
  end
end
