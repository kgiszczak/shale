# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__UsingBlock # rubocop:disable Naming/ClassAndModuleCamelCase
  class GroupWithoutContext < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String
    attribute :three, Shale::Type::String

    hsh do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    json do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    yaml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    toml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    csv do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    xml do
      root 'el'
      group from: :attrs_from_xml, to: :attrs_to_xml do
        map_element 'one'
        map_attribute 'two'
        map_content
      end
    end

    def attrs_from_dict(model, value)
      model.one = value['one']
      model.two = value['two']
    end

    def attrs_to_dict(model, doc)
      doc['one'] = model.one
      doc['two'] = model.two
    end

    def attrs_from_xml(model, value)
      model.one = value[:elements]['one'].text
      model.two = value[:attributes]['two']
      model.three = value[:content].text
    end

    def attrs_to_xml(model, element, doc)
      doc.add_attribute(element, 'two', model.two)
      doc.add_text(element, model.three)

      one = doc.create_element('one')
      doc.add_text(one, model.one)
      doc.add_element(element, one)
    end
  end

  class GroupWithContext < Shale::Mapper
    attribute :one, Shale::Type::String
    attribute :two, Shale::Type::String
    attribute :three, Shale::Type::String

    hsh do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    json do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    yaml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    toml do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    csv do
      group from: :attrs_from_dict, to: :attrs_to_dict do
        map 'one'
        map 'two'
      end
    end

    xml do
      root 'el'
      group from: :attrs_from_xml, to: :attrs_to_xml do
        map_element 'one'
        map_attribute 'two'
        map_content
      end
    end

    def attrs_from_dict(model, value, context)
      model.one = "#{value['one']}:#{context}"
      model.two = "#{value['two']}:#{context}"
    end

    def attrs_to_dict(model, doc, context)
      doc['one'] = "#{model.one}:#{context}"
      doc['two'] = "#{model.two}:#{context}"
    end

    def attrs_from_xml(model, value, context)
      model.one = "#{value[:elements]['one'].text}:#{context}"
      model.two = "#{value[:attributes]['two']}:#{context}"
      model.three = "#{value[:content].text}:#{context}"
    end

    def attrs_to_xml(model, element, doc, context)
      doc.add_attribute(element, 'two', "#{model.two}:#{context}")
      doc.add_text(element, "#{model.three}:#{context}")

      one = doc.create_element('one')
      doc.add_text(one, "#{model.one}:#{context}")
      doc.add_element(element, one)
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

  context 'with using block' do
    context 'without context' do
      let(:mapper) { ComplexSpec__UsingBlock::GroupWithoutContext }

      context 'with hash mapping' do
        let(:hash) do
          {
            'one' => 'one',
            'two' => 'two',
          }
        end

        let(:hash_collection) do
          [hash, hash]
        end

        describe '.from_hash' do
          it 'maps hash to object' do
            instance = mapper.from_hash(hash)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end

          it 'maps collection to object' do
            instance = mapper.from_hash(hash_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].two).to eq('two')
            end
          end
        end

        describe '.to_hash' do
          it 'converts objects to hash' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_hash
            expect(result).to eq({
              'one' => 'one',
              'two' => 'two',
            })
          end

          it 'converts array to hash' do
            instance = mapper.new(one: 'one', two: 'two')
            expect(mapper.to_hash([instance, instance])).to eq(hash_collection)
          end
        end
      end

      context 'with JSON mapping' do
        let(:json) do
          <<~DOC.gsub(/\n\z/, '')
            {
              "one": "one",
              "two": "two"
            }
          DOC
        end

        let(:json_collection) do
          <<~DOC.gsub(/\n\z/, '')
            [
              {
                "one": "one",
                "two": "two"
              },
              {
                "one": "one",
                "two": "two"
              }
            ]
          DOC
        end

        describe '.from_json' do
          it 'maps JSON to object' do
            instance = mapper.from_json(json)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end

          it 'maps collection to object' do
            instance = mapper.from_json(json_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].two).to eq('two')
            end
          end
        end

        describe '.to_json' do
          it 'converts objects to JSON' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_json(pretty: true)
            expect(result).to eq(json)
          end

          it 'converts array to JSON' do
            instance = mapper.new(one: 'one', two: 'two')
            expect(mapper.to_json([instance, instance], pretty: true)).to eq(json_collection)
          end
        end
      end

      context 'with YAML mapping' do
        let(:yaml) do
          <<~DOC
            ---
            one: one
            two: two
          DOC
        end

        let(:yaml_collection) do
          <<~DOC
            ---
            - one: one
              two: two
            - one: one
              two: two
          DOC
        end

        describe '.from_yaml' do
          it 'maps YAML to object' do
            instance = mapper.from_yaml(yaml)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end

          it 'maps collection to object' do
            instance = mapper.from_yaml(yaml_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].two).to eq('two')
            end
          end
        end

        describe '.to_yaml' do
          it 'converts objects to YAML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_yaml
            expect(result).to eq(yaml)
          end

          it 'converts array to YAML' do
            instance = mapper.new(one: 'one', two: 'two')
            expect(mapper.to_yaml([instance, instance])).to eq(yaml_collection)
          end
        end
      end

      context 'with TOML mapping' do
        let(:toml) do
          <<~DOC
            one = "one"
            two = "two"
          DOC
        end

        describe '.from_toml' do
          it 'maps TOML to object' do
            instance = mapper.from_toml(toml)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end
        end

        describe '.to_toml' do
          it 'converts objects to TOML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_toml
            expect(result).to eq(toml)
          end
        end
      end

      context 'with CSV mapping' do
        let(:csv) do
          <<~DOC
            one,two
          DOC
        end

        let(:csv_collection) do
          <<~DOC
            one,two
            one,two
          DOC
        end

        describe '.from_csv' do
          it 'maps CSV to object' do
            instance = mapper.from_csv(csv)[0]

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
          end

          it 'maps collection to object' do
            instance = mapper.from_csv(csv_collection)

            2.times do |i|
              expect(instance[i].one).to eq('one')
              expect(instance[i].two).to eq('two')
            end
          end
        end

        describe '.to_csv' do
          it 'converts objects to CSV' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_csv
            expect(result).to eq(csv)
          end

          it 'converts array to CSV' do
            instance = mapper.new(one: 'one', two: 'two')
            expect(mapper.to_csv([instance, instance])).to eq(csv_collection)
          end
        end
      end

      context 'with XML mapping' do
        let(:xml) do
          <<~DOC
            <el two="two">three<one>one</one></el>
          DOC
        end

        describe '.from_xml' do
          it 'maps XML to object' do
            instance = mapper.from_xml(xml)

            expect(instance.one).to eq('one')
            expect(instance.two).to eq('two')
            expect(instance.three).to eq('three')
          end
        end

        describe '.to_xml' do
          it 'converts objects to XML' do
            instance = mapper.new(one: 'one', two: 'two', three: 'three')

            result = instance.to_xml

            expect(result).to eq('<el two="two">three<one>one</one></el>')
          end
        end
      end
    end

    context 'with context' do
      let(:mapper) { ComplexSpec__UsingBlock::GroupWithContext }

      context 'with hash mapping' do
        let(:hash) do
          {
            'one' => 'one',
            'two' => 'two',
          }
        end

        let(:hash_collection) do
          [hash, hash]
        end

        describe '.from_hash' do
          it 'maps hash to object' do
            instance = mapper.from_hash(hash, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.two).to eq('two:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_hash(hash_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
              expect(instance[i].two).to eq('two:foo')
            end
          end
        end

        describe '.to_hash' do
          it 'converts objects to hash' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_hash(context: 'foo')
            expect(result).to eq({
              'one' => 'one:foo',
              'two' => 'two:foo',
            })
          end

          it 'converts array to hash' do
            instance = mapper.new(one: 'one', two: 'two')
            result = mapper.to_hash([instance, instance], context: 'foo')
            expect(result).to eq([
              { 'one' => 'one:foo', 'two' => 'two:foo' },
              { 'one' => 'one:foo', 'two' => 'two:foo' },
            ])
          end
        end
      end

      context 'with JSON mapping' do
        let(:json) do
          <<~DOC
            {
              "one": "one",
              "two": "two"
            }
          DOC
        end

        let(:json_collection) do
          <<~DOC
            [
              {
                "one": "one",
                "two": "two"
              },
              {
                "one": "one",
                "two": "two"
              }
            ]
          DOC
        end

        describe '.from_json' do
          it 'maps JSON to object' do
            instance = mapper.from_json(json, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.two).to eq('two:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_json(json_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
              expect(instance[i].two).to eq('two:foo')
            end
          end
        end

        describe '.to_json' do
          it 'converts objects to JSON' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_json(pretty: true, context: 'foo')
            expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
              {
                "one": "one:foo",
                "two": "two:foo"
              }
            DOC
          end

          it 'converts array to JSON' do
            instance = mapper.new(one: 'one', two: 'two')
            result = mapper.to_json([instance, instance], context: 'foo')
            expect(result).to eq(<<~DOC.gsub(/\n|\s/, ''))
              [
                { "one": "one:foo", "two": "two:foo" },
                { "one": "one:foo", "two": "two:foo" }
              ]
            DOC
          end
        end
      end

      context 'with YAML mapping' do
        let(:yaml) do
          <<~DOC
            ---
            one: one
            two: two
          DOC
        end

        let(:yaml_collection) do
          <<~DOC
            ---
            - one: one
              two: two
            - one: one
              two: two
          DOC
        end

        describe '.from_yaml' do
          it 'maps YAML to object' do
            instance = mapper.from_yaml(yaml, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.two).to eq('two:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_yaml(yaml_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
              expect(instance[i].two).to eq('two:foo')
            end
          end
        end

        describe '.to_yaml' do
          it 'converts objects to YAML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_yaml(context: 'foo')
            expect(result).to eq(<<~DOC)
              ---
              one: one:foo
              two: two:foo
            DOC
          end

          it 'converts array to YAML' do
            instance = mapper.new(one: 'one', two: 'two')
            result = mapper.to_yaml([instance, instance], context: 'foo')
            expect(result).to eq(<<~DOC)
              ---
              - one: one:foo
                two: two:foo
              - one: one:foo
                two: two:foo
            DOC
          end
        end
      end

      context 'with TOML mapping' do
        let(:toml) do
          <<~DOC
            one = "one"
            two = "two"
          DOC
        end

        describe '.from_toml' do
          it 'maps TOML to object' do
            instance = mapper.from_toml(toml, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.two).to eq('two:foo')
          end
        end

        describe '.to_toml' do
          it 'converts objects to TOML' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_toml(context: 'foo')
            expect(result).to eq(<<~DOC)
              one = "one:foo"
              two = "two:foo"
            DOC
          end
        end
      end

      context 'with CSV mapping' do
        let(:csv) do
          <<~DOC
            one,two
          DOC
        end

        let(:csv_collection) do
          <<~DOC
            one,two
            one,two
          DOC
        end

        describe '.from_csv' do
          it 'maps CSV to object' do
            instance = mapper.from_csv(csv, context: 'foo')[0]

            expect(instance.one).to eq('one:foo')
            expect(instance.two).to eq('two:foo')
          end

          it 'maps collection to object' do
            instance = mapper.from_csv(csv_collection, context: 'foo')

            2.times do |i|
              expect(instance[i].one).to eq('one:foo')
              expect(instance[i].two).to eq('two:foo')
            end
          end
        end

        describe '.to_csv' do
          it 'converts objects to CSV' do
            instance = mapper.new(one: 'one', two: 'two')

            result = instance.to_csv(context: 'foo')
            expect(result).to eq(<<~DOC)
              one:foo,two:foo
            DOC
          end

          it 'converts array to CSV' do
            instance = mapper.new(one: 'one', two: 'two')

            result = mapper.to_csv([instance, instance], context: 'foo')
            expect(result).to eq(<<~DOC)
              one:foo,two:foo
              one:foo,two:foo
            DOC
          end
        end
      end

      context 'with XML mapping' do
        let(:xml) do
          <<~DOC
            <el two="two">three<one>one</one></el>
          DOC
        end

        describe '.from_xml' do
          it 'maps XML to object' do
            instance = mapper.from_xml(xml, context: 'foo')

            expect(instance.one).to eq('one:foo')
            expect(instance.two).to eq('two:foo')
            expect(instance.three).to eq('three:foo')
          end
        end

        describe '.to_xml' do
          it 'converts objects to XML' do
            instance = mapper.new(one: 'one', two: 'two', three: 'three')

            result = instance.to_xml(context: 'foo')

            expect(result).to eq('<el two="two:foo">three:foo<one>one:foo</one></el>')
          end
        end
      end
    end
  end
end
