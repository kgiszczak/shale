# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__CustomModels # rubocop:disable Naming/ClassAndModuleCamelCase
  class Child
    attr_accessor :one

    def initialize(one: nil)
      @one = one
    end
  end

  class Parent
    attr_accessor :one, :child

    def initialize(one: nil, child: nil)
      @one = one
      @child = child
    end
  end

  class ChildMapper < Shale::Mapper
    model Child

    attribute :one, Shale::Type::String
  end

  class ParentMapper < Shale::Mapper
    model Parent

    attribute :one, Shale::Type::String
    attribute :child, ChildMapper
  end

  class ParentMapperCsv < Shale::Mapper
    model Parent
    attribute :one, Shale::Type::String
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

  context 'with custom models' do
    let(:parent_mapper) { ComplexSpec__CustomModels::ParentMapper }
    let(:parent_model_class) { ComplexSpec__CustomModels::Parent }
    let(:child_model_class) { ComplexSpec__CustomModels::Child }

    context 'with hash mapping' do
      let(:hash) do
        { 'one' => 'one', 'child' => { 'one' => 'one' } }
      end

      let(:hash_collection) do
        [hash, hash]
      end

      describe '.from_hash' do
        it 'maps hash to object' do
          instance = parent_mapper.from_hash(hash)

          expect(instance.class).to eq(parent_model_class)
          expect(instance.one).to eq('one')
          expect(instance.child.class).to eq(child_model_class)
          expect(instance.child.one).to eq('one')
        end

        it 'maps collection to array' do
          instance = parent_mapper.from_hash(hash_collection)

          2.times do |i|
            expect(instance[i].class).to eq(parent_model_class)
            expect(instance[i].one).to eq('one')
            expect(instance[i].child.class).to eq(child_model_class)
            expect(instance[i].child.one).to eq('one')
          end
        end
      end

      describe '.to_hash' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a '#{parent_model_class.name}/

            expect do
              parent_mapper.to_hash('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to hash' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            expect(parent_mapper.to_hash(instance)).to eq(hash)
          end

          it 'converts objects to array' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            result = parent_mapper.to_hash([instance, instance])
            expect(result).to eq(hash_collection)
          end
        end
      end
    end

    context 'with json mapping' do
      let(:json) do
        <<~DOC.gsub(/\n\z/, '')
          {
            "one": "one",
            "child": {
              "one": "one"
            }
          }
        DOC
      end

      let(:json_collection) do
        <<~DOC.gsub(/\n\z/, '')
          [
            {
              "one": "one",
              "child": {
                "one": "one"
              }
            },
            {
              "one": "one",
              "child": {
                "one": "one"
              }
            }
          ]
        DOC
      end

      describe '.from_json' do
        it 'maps json to object' do
          instance = parent_mapper.from_json(json)

          expect(instance.class).to eq(parent_model_class)
          expect(instance.one).to eq('one')
          expect(instance.child.class).to eq(child_model_class)
          expect(instance.child.one).to eq('one')
        end

        it 'maps collection to array' do
          instance = parent_mapper.from_json(json_collection)

          2.times do |i|
            expect(instance[i].class).to eq(parent_model_class)
            expect(instance[i].one).to eq('one')
            expect(instance[i].child.class).to eq(child_model_class)
            expect(instance[i].child.one).to eq('one')
          end
        end
      end

      describe '.to_json' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a '#{parent_model_class.name}/

            expect do
              parent_mapper.to_json('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to json' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            expect(parent_mapper.to_json(instance, pretty: true)).to eq(json)
          end

          it 'converts objects to array' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            result = parent_mapper.to_json([instance, instance], pretty: true)
            expect(result).to eq(json_collection)
          end
        end
      end
    end

    context 'with yaml mapping' do
      let(:yaml) do
        <<~DOC
          ---
          one: one
          child:
            one: one
        DOC
      end

      let(:yaml_collection) do
        <<~DOC
          ---
          - one: one
            child:
              one: one
          - one: one
            child:
              one: one
        DOC
      end

      describe '.from_yaml' do
        it 'maps yaml to object' do
          instance = parent_mapper.from_yaml(yaml)

          expect(instance.class).to eq(parent_model_class)
          expect(instance.one).to eq('one')
          expect(instance.child.class).to eq(child_model_class)
          expect(instance.child.one).to eq('one')
        end

        it 'maps collection to array' do
          instance = parent_mapper.from_yaml(yaml_collection)

          2.times do |i|
            expect(instance[i].class).to eq(parent_model_class)
            expect(instance[i].one).to eq('one')
            expect(instance[i].child.class).to eq(child_model_class)
            expect(instance[i].child.one).to eq('one')
          end
        end
      end

      describe '.to_yaml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a '#{parent_model_class.name}/

            expect do
              parent_mapper.to_yaml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to yaml' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            expect(parent_mapper.to_yaml(instance)).to eq(yaml)
          end

          it 'converts objects to array' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            result = parent_mapper.to_yaml([instance, instance])
            expect(result).to eq(yaml_collection)
          end
        end
      end
    end

    context 'with toml mapping' do
      let(:toml) do
        <<~DOC
          one = "one"

          [child]
          one = "one"
        DOC
      end

      describe '.from_toml' do
        it 'maps toml to object' do
          instance = parent_mapper.from_toml(toml)

          expect(instance.class).to eq(parent_model_class)
          expect(instance.one).to eq('one')
          expect(instance.child.class).to eq(child_model_class)
          expect(instance.child.one).to eq('one')
        end
      end

      describe '.to_toml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a '#{parent_model_class.name}/

            expect do
              parent_mapper.to_toml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to toml' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            expect(parent_mapper.to_toml(instance)).to eq(toml)
          end
        end
      end
    end

    context 'with csv mapping' do
      let(:parent_mapper) { ComplexSpec__CustomModels::ParentMapperCsv }

      let(:csv) do
        <<~DOC
          one
        DOC
      end

      let(:csv_collection) do
        <<~DOC
          one
          one
        DOC
      end

      describe '.from_csv' do
        it 'maps csv to object' do
          instance = parent_mapper.from_csv(csv)

          expect(instance[0].class).to eq(parent_model_class)
          expect(instance[0].one).to eq('one')
        end

        it 'maps collection to array' do
          instance = parent_mapper.from_csv(csv_collection)

          2.times do |i|
            expect(instance[i].class).to eq(parent_model_class)
            expect(instance[i].one).to eq('one')
          end
        end
      end

      describe '.to_csv' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a '#{parent_model_class.name}/

            expect do
              parent_mapper.to_csv('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to csv' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            expect(parent_mapper.to_csv(instance)).to eq(csv)
          end

          it 'converts objects to array' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            result = parent_mapper.to_csv([instance, instance])
            expect(result).to eq(csv_collection)
          end
        end
      end
    end

    context 'with xml mapping' do
      let(:xml) do
        <<~DOC.gsub(/\n\z/, '')
          <parent>
            <one>one</one>
            <child>
              <one>one</one>
            </child>
          </parent>
        DOC
      end

      describe '.from_xml' do
        it 'maps xml to object' do
          instance = parent_mapper.from_xml(xml)

          expect(instance.class).to eq(parent_model_class)
          expect(instance.one).to eq('one')
          expect(instance.child.class).to eq(child_model_class)
          expect(instance.child.one).to eq('one')
        end
      end

      describe '.to_xml' do
        context 'with wrong model' do
          it 'raises an exception' do
            msg = /argument is a 'String' but should be a '#{parent_model_class.name}/

            expect do
              parent_mapper.to_xml('')
            end.to raise_error(Shale::IncorrectModelError, msg)
          end
        end

        context 'with correct model' do
          it 'converts objects to xml' do
            instance = parent_model_class.new(
              one: 'one',
              child: child_model_class.new(one: 'one')
            )

            expect(parent_mapper.to_xml(instance, pretty: true)).to eq(xml)
          end
        end
      end
    end
  end
end
