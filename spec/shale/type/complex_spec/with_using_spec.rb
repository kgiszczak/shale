# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__Using # rubocop:disable Naming/ClassAndModuleCamelCase
  class UsingWithoutContext < Shale::Mapper
    class Child < Shale::Mapper
      attribute :one, Shale::Type::String
      attribute :two, Shale::Type::String
      attribute :three, Shale::Type::String

      hsh do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      json do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      yaml do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      toml do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      xml do
        root 'child'

        map_content using: { from: :one_from_xml, to: :one_to_xml }
        map_element 'two', using: { from: :two_from_xml, to: :two_to_xml }
        map_attribute 'three', using: { from: :three_from_xml, to: :three_to_xml }
      end

      def one_from(model, value)
        model.one = value
      end

      def one_to(model, doc)
        doc['one'] = model.one
      end

      def one_from_xml(model, node)
        model.one = node.text.strip
      end

      def one_to_xml(model, parent, doc)
        doc.add_text(parent, model.one)
      end

      def two_from_xml(model, node)
        model.two = node.text
      end

      def two_to_xml(model, parent, doc)
        el = doc.create_element('two')
        doc.add_text(el, model.two)
        doc.add_element(parent, el)
      end

      def three_from_xml(model, value)
        model.three = value
      end

      def three_to_xml(model, parent, doc)
        doc.add_attribute(parent, 'three', model.three)
      end
    end

    class Parent < Shale::Mapper
      attribute :one, Shale::Type::String
      attribute :two, Shale::Type::String
      attribute :three, Shale::Type::String
      attribute :child, Child

      hsh do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      json do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      yaml do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      toml do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      csv do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      xml do
        root 'parent'

        map_content using: { from: :one_from_xml, to: :one_to_xml }
        map_element 'two', using: { from: :two_from_xml, to: :two_to_xml }
        map_attribute 'three', using: { from: :three_from_xml, to: :three_to_xml }
        map_element 'child', to: :child
      end

      def one_from(model, value)
        model.one = value
      end

      def one_to(model, doc)
        doc['one'] = model.one
      end

      def one_from_xml(model, node)
        model.one = node.text.strip
      end

      def one_to_xml(model, parent, doc)
        doc.add_text(parent, model.one)
      end

      def two_from_xml(model, node)
        model.two = node.text
      end

      def two_to_xml(model, parent, doc)
        el = doc.create_element('two')
        doc.add_text(el, model.two)
        doc.add_element(parent, el)
      end

      def three_from_xml(model, value)
        model.three = value
      end

      def three_to_xml(model, parent, doc)
        doc.add_attribute(parent, 'three', model.three)
      end
    end
  end

  class UsingWithContext < Shale::Mapper
    class Child < Shale::Mapper
      attribute :one, Shale::Type::String
      attribute :two, Shale::Type::String
      attribute :three, Shale::Type::String

      hsh do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      json do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      yaml do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      toml do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      xml do
        root 'child'

        map_content using: { from: :one_from_xml, to: :one_to_xml }
        map_element 'two', using: { from: :two_from_xml, to: :two_to_xml }
        map_attribute 'three', using: { from: :three_from_xml, to: :three_to_xml }
      end

      def one_from(model, value, context)
        model.one = "#{value}:#{context}"
      end

      def one_to(model, doc, context)
        doc['one'] = "#{model.one}:#{context}"
      end

      def one_from_xml(model, node, context)
        model.one = "#{node.text.strip}:#{context}"
      end

      def one_to_xml(model, parent, doc, context)
        doc.add_text(parent, "#{model.one}:#{context}")
      end

      def two_from_xml(model, node, context)
        model.two = "#{node.text}:#{context}"
      end

      def two_to_xml(model, parent, doc, context)
        el = doc.create_element('two')
        doc.add_text(el, "#{model.two}:#{context}")
        doc.add_element(parent, el)
      end

      def three_from_xml(model, value, context)
        model.three = "#{value}:#{context}"
      end

      def three_to_xml(model, parent, doc, context)
        doc.add_attribute(parent, 'three', "#{model.three}:#{context}")
      end
    end

    class Parent < Shale::Mapper
      attribute :one, Shale::Type::String
      attribute :two, Shale::Type::String
      attribute :three, Shale::Type::String
      attribute :child, Child

      hsh do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      json do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      yaml do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      toml do
        map 'one', using: { from: :one_from, to: :one_to }
        map 'child', to: :child
      end

      csv do
        map 'one', using: { from: :one_from, to: :one_to }
      end

      xml do
        root 'parent'

        map_content using: { from: :one_from_xml, to: :one_to_xml }
        map_element 'two', using: { from: :two_from_xml, to: :two_to_xml }
        map_attribute 'three', using: { from: :three_from_xml, to: :three_to_xml }
        map_element 'child', to: :child
      end

      def one_from(model, value, context)
        model.one = "#{value}:#{context}"
      end

      def one_to(model, doc, context)
        doc['one'] = "#{model.one}:#{context}"
      end

      def one_from_xml(model, node, context)
        model.one = "#{node.text.strip}:#{context}"
      end

      def one_to_xml(model, parent, doc, context)
        doc.add_text(parent, "#{model.one}:#{context}")
      end

      def two_from_xml(model, node, context)
        model.two = "#{node.text}:#{context}"
      end

      def two_to_xml(model, parent, doc, context)
        el = doc.create_element('two')
        doc.add_text(el, "#{model.two}:#{context}")
        doc.add_element(parent, el)
      end

      def three_from_xml(model, value, context)
        model.three = "#{value}:#{context}"
      end

      def three_to_xml(model, parent, doc, context)
        doc.add_attribute(parent, 'three', "#{model.three}:#{context}")
      end
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

  context 'with using option' do
    context 'without context' do
      let(:mapper) { ComplexSpec__Using::UsingWithoutContext::Parent }
      let(:child_class) { ComplexSpec__Using::UsingWithoutContext::Child }

      context 'with hash mapping' do
        let(:hash) do
          {
            'one' => 'one',
            'child' => {
              'one' => 'one',
            },
          }
        end

        let(:hash_collection) do
          [hash, hash]
        end

        describe '.from_hash' do
          it 'maps hash to object' do
            instance = mapper.from_hash(hash)

            expect(instance.one).to eq('one')
            expect(instance.child.one).to eq('one')
          end

          it 'maps collection to object' do
            instance = mapper.from_hash(hash_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].child.one).to eq('one')
            end
          end
        end

        describe '.to_hash' do
          it 'converts objects to hash' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_hash
            expect(result).to eq(hash)
          end

          it 'converts array to hash' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_hash([instance, instance])
            expect(result).to eq(hash_collection)
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
            instance = mapper.from_json(json)

            expect(instance.one).to eq('one')
            expect(instance.child.one).to eq('one')
          end

          it 'maps collection to object' do
            instance = mapper.from_json(json_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].child.one).to eq('one')
            end
          end
        end

        describe '.to_json' do
          it 'converts objects to json' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_json(pretty: true)
            expect(result).to eq(json)
          end

          it 'converts array to json' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_json([instance, instance], pretty: true)
            expect(result).to eq(json_collection)
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
            instance = mapper.from_yaml(yaml)

            expect(instance.one).to eq('one')
            expect(instance.child.one).to eq('one')
          end

          it 'maps collection to object' do
            instance = mapper.from_yaml(yaml_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].child.one).to eq('one')
            end
          end
        end

        describe '.to_yaml' do
          it 'converts objects to yaml' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_yaml
            expect(result).to eq(yaml)
          end

          it 'converts array to yaml' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_yaml([instance, instance])
            expect(result).to eq(yaml_collection)
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
            instance = mapper.from_toml(toml)

            expect(instance.one).to eq('one')
            expect(instance.child.one).to eq('one')
          end
        end

        describe '.to_toml' do
          it 'converts objects to toml' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_toml
            expect(result).to eq(toml)
          end
        end
      end

      context 'with csv mapping' do
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
            instance = mapper.from_csv(csv)
            expect(instance[0].one).to eq('one')
          end

          it 'maps collection to object' do
            instance = mapper.from_csv(csv_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
            end
          end
        end

        describe '.to_csv' do
          it 'converts objects to csv' do
            instance = mapper.new(one: 'one')

            result = instance.to_csv
            expect(result).to eq(csv)
          end

          it 'converts array to csv' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_csv([instance, instance])
            expect(result).to eq(csv_collection)
          end
        end
      end

      context 'with xml mapping' do
        let(:xml) do
          <<~DOC.gsub(/\n\z/, '')
            <parent three="three">
              one
              <two>two</two>
              <child three="three">
                one
                <two>two</two>
              </child>
            </parent>
          DOC
        end

        describe '.from_xml' do
          it 'maps xml to object' do
            instance = mapper.from_xml(xml)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
            expect(instance.three).to eq('three')

            expect(instance.child.one).to eq('one')
            expect(instance.child.two).to eq('two')
            expect(instance.child.three).to eq('three')
          end
        end

        describe '.to_xml' do
          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'one',
              two: 'two',
              three: 'three',
              child: child_class.new(one: 'one', two: 'two', three: 'three')
            )

            result = instance.to_xml(pretty: true)
            expect(result).to eq(xml)
          end
        end
      end
    end

    context 'with context' do
      let(:mapper) { ComplexSpec__Using::UsingWithContext::Parent }
      let(:child_class) { ComplexSpec__Using::UsingWithContext::Child }

      context 'with hash mapping' do
        describe '.from_hash' do
          let(:hash) do
            {
              'one' => 'one',
              'child' => {
                'one' => 'one',
              },
            }
          end

          let(:hash_collection) do
            [hash, hash]
          end

          it 'maps hash to object' do
            instance = mapper.from_hash(hash, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.child.one).to eq('one:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_hash(hash_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
              expect(instance[i].child.one).to eq('one:foo')
            end
          end
        end

        describe '.to_hash' do
          let(:hash) do
            {
              'one' => 'one:foo',
              'child' => {
                'one' => 'one:foo',
              },
            }
          end

          let(:hash_collection) do
            [hash, hash]
          end

          it 'converts objects to hash' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_hash(context: 'foo')
            expect(result).to eq(hash)
          end

          it 'converts array to hash' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_hash([instance, instance], context: 'foo')
            expect(result).to eq(hash_collection)
          end
        end
      end

      context 'with json mapping' do
        describe '.from_json' do
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

          it 'maps json to object' do
            instance = mapper.from_json(json, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.child.one).to eq('one:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_json(json_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
              expect(instance[i].child.one).to eq('one:foo')
            end
          end
        end

        describe '.to_json' do
          let(:json) do
            <<~DOC.gsub(/\n\z/, '')
              {
                "one": "one:foo",
                "child": {
                  "one": "one:foo"
                }
              }
            DOC
          end

          let(:json_collection) do
            <<~DOC.gsub(/\n\z/, '')
              [
                {
                  "one": "one:foo",
                  "child": {
                    "one": "one:foo"
                  }
                },
                {
                  "one": "one:foo",
                  "child": {
                    "one": "one:foo"
                  }
                }
              ]
            DOC
          end

          it 'converts objects to json' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_json(pretty: true, context: 'foo')
            expect(result).to eq(json)
          end

          it 'converts array to json' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_json([instance, instance], pretty: true, context: 'foo')
            expect(result).to eq(json_collection)
          end
        end
      end

      context 'with yaml mapping' do
        describe '.from_yaml' do
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

          it 'maps yaml to object' do
            instance = mapper.from_yaml(yaml, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.child.one).to eq('one:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_yaml(yaml_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
              expect(instance[i].child.one).to eq('one:foo')
            end
          end
        end

        describe '.to_yaml' do
          let(:yaml) do
            <<~DOC
              ---
              one: one:foo
              child:
                one: one:foo
            DOC
          end

          let(:yaml_collection) do
            <<~DOC
              ---
              - one: one:foo
                child:
                  one: one:foo
              - one: one:foo
                child:
                  one: one:foo
            DOC
          end

          it 'converts objects to yaml' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_yaml(context: 'foo')
            expect(result).to eq(yaml)
          end

          it 'converts array to yaml' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_yaml([instance, instance], context: 'foo')
            expect(result).to eq(yaml_collection)
          end
        end
      end

      context 'with toml mapping' do
        describe '.from_toml' do
          let(:toml) do
            <<~DOC
              one = "one"

              [child]
              one = "one"
            DOC
          end

          it 'maps toml to object' do
            instance = mapper.from_toml(toml, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.child.one).to eq('one:foo')
          end
        end

        describe '.to_toml' do
          let(:toml) do
            <<~DOC
              one = "one:foo"

              [child]
              one = "one:foo"
            DOC
          end

          it 'converts objects to toml' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = instance.to_toml(context: 'foo')
            expect(result).to eq(toml)
          end
        end
      end

      context 'with csv mapping' do
        describe '.from_csv' do
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

          it 'maps csv to object' do
            instance = mapper.from_csv(csv, context: 'foo')
            expect(instance[0].one).to eq('one:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_csv(csv_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
            end
          end
        end

        describe '.to_csv' do
          let(:csv) do
            <<~DOC
              one:foo
            DOC
          end

          let(:csv_collection) do
            <<~DOC
              one:foo
              one:foo
            DOC
          end

          it 'converts objects to csv' do
            instance = mapper.new(one: 'one')

            result = instance.to_csv(context: 'foo')
            expect(result).to eq(csv)
          end

          it 'converts array to csv' do
            instance = mapper.new(one: 'one', child: child_class.new(one: 'one'))

            result = mapper.to_csv([instance, instance], context: 'foo')
            expect(result).to eq(csv_collection)
          end
        end
      end

      context 'with xml mapping' do
        describe '.from_xml' do
          let(:xml) do
            <<~DOC.gsub(/\n\z/, '')
              <parent three="three">
                one
                <two>two</two>
                <child three="three">
                  one
                  <two>two</two>
                </child>
              </parent>
            DOC
          end

          it 'maps xml to object' do
            instance = mapper.from_xml(xml, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.two).to eq('two:foo')
            expect(instance.three).to eq('three:foo')

            expect(instance.child.one).to eq('one:foo')
            expect(instance.child.two).to eq('two:foo')
            expect(instance.child.three).to eq('three:foo')
          end
        end

        describe '.to_xml' do
          let(:xml) do
            <<~DOC.gsub(/\n\z/, '')
              <parent three="three:foo">
                one:foo
                <two>two:foo</two>
                <child three="three:foo">
                  one:foo
                  <two>two:foo</two>
                </child>
              </parent>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              one: 'one',
              two: 'two',
              three: 'three',
              child: child_class.new(one: 'one', two: 'two', three: 'three')
            )

            result = instance.to_xml(pretty: true, context: 'foo')
            expect(result).to eq(xml)
          end
        end
      end
    end
  end
end
