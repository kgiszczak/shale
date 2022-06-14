# frozen_string_literal: true

require 'shale/schema/json_compiler'

RSpec.describe Shale::Schema::JSONCompiler do
  let(:schema) do
    <<~DATA
      {
        "type": "object",
        "properties": {
          "typeBoolean": { "type": "boolean" },
          "typeDate": { "type": "string", "format": "date" },
          "typeFloat": { "type": "number" },
          "typeInteger": { "type": "integer" },
          "typeString": { "type": "string" },
          "typeTime": { "type": "string", "format": "date-time" },
          "typeUnknown": { "type": "foo" },
          "typeWithDefault": { "type": "string", "default": "foobar" },
          "typeMultipleWithNull": { "type": ["string", "null"] },
          "typeMultipleWithoutNull": { "type": ["string", "number"] },
          "typeArrayWithItems": {
            "type": "array",
            "items": { "type": "string" }
          },
          "typeArrayWithoutItems": {
            "type": "array"
          },
          "schemaFalse": false,
          "schemaTrue": true,
          "address": {
            "type": "object",
            "properties": {
              "street": { "type": "string" }
            }
          },
          "shipping": {
            "$ref": "http://foo.com/schemas/address"
          },
          "billing": {
            "$ref": "#/properties/shipping"
          },
          "mailing": {
            "$id": "http://foo.com/schemas/mailing",
            "type": "string"
          }
        },
        "$defs": {
          "address": {
            "$id": "http://foo.com/schemas/address",
            "type": "object",
            "properties": {
              "city": { "type": "string" }
            }
          }
        }
      }
    DATA
  end

  describe '#as_models' do
    context 'when duplicate schemas exists' do
      let(:schema) do
        <<~DATA
          {
            "$id": "foo",
            "$defs": {
              "foo": {
                "$id": "foo"
              }
            }
          }
        DATA
      end

      it 'raises error' do
        expect do
          described_class.new.as_models([schema])
        end.to raise_error(Shale::JSONSchemaError, "schema with id 'foo' already exists")
      end
    end

    context 'when can not resolve schema' do
      let(:schema) do
        <<~DATA
          {
            "type": "object",
            "$ref": "#/$defs/bar",
            "$defs": {
              "foo": {
                "type": "object"
              }
            }
          }
        DATA
      end

      it 'raises error' do
        expect do
          described_class.new.as_models([schema])
        end.to raise_error(Shale::JSONSchemaError, "can't resolve reference '#/$defs/bar'")
      end
    end

    context 'with correct schema' do
      it 'generates Shale models' do
        models = described_class.new.as_models([schema])

        expect(models.length).to eq(3)

        expect(models[0].id).to eq('http://foo.com/schemas/address')
        expect(models[0].name).to eq('Address2')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('city')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)

        expect(models[1].id).to eq('#/properties/address')
        expect(models[1].name).to eq('Address1')
        expect(models[1].properties.length).to eq(1)
        expect(models[1].properties[0].mapping_name).to eq('street')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)

        props = models[2].properties
        expect(models[2].id).to eq('')
        expect(models[2].name).to eq('Root')
        expect(props.length).to eq(17)

        expect(props[0].mapping_name).to eq('typeBoolean')
        expect(props[0].type).to be_a(Shale::Schema::Compiler::Boolean)
        expect(props[0].collection?).to eq(false)
        expect(props[0].default).to eq(nil)

        expect(props[1].mapping_name).to eq('typeDate')
        expect(props[1].type).to be_a(Shale::Schema::Compiler::Date)
        expect(props[1].collection?).to eq(false)
        expect(props[1].default).to eq(nil)

        expect(props[2].mapping_name).to eq('typeFloat')
        expect(props[2].type).to be_a(Shale::Schema::Compiler::Float)
        expect(props[2].collection?).to eq(false)
        expect(props[2].default).to eq(nil)

        expect(props[3].mapping_name).to eq('typeInteger')
        expect(props[3].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(props[3].collection?).to eq(false)
        expect(props[3].default).to eq(nil)

        expect(props[4].mapping_name).to eq('typeString')
        expect(props[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(props[4].collection?).to eq(false)
        expect(props[4].default).to eq(nil)

        expect(props[5].mapping_name).to eq('typeTime')
        expect(props[5].type).to be_a(Shale::Schema::Compiler::Time)
        expect(props[5].collection?).to eq(false)
        expect(props[5].default).to eq(nil)

        expect(props[6].mapping_name).to eq('typeUnknown')
        expect(props[6].type).to be_a(Shale::Schema::Compiler::Value)
        expect(props[6].collection?).to eq(false)
        expect(props[6].default).to eq(nil)

        expect(props[7].mapping_name).to eq('typeWithDefault')
        expect(props[7].type).to be_a(Shale::Schema::Compiler::String)
        expect(props[7].collection?).to eq(false)
        expect(props[7].default).to eq('"foobar"')

        expect(props[8].mapping_name).to eq('typeMultipleWithNull')
        expect(props[8].type).to be_a(Shale::Schema::Compiler::String)
        expect(props[8].collection?).to eq(false)
        expect(props[8].default).to eq(nil)

        expect(props[9].mapping_name).to eq('typeMultipleWithoutNull')
        expect(props[9].type).to be_a(Shale::Schema::Compiler::Value)
        expect(props[9].collection?).to eq(false)
        expect(props[9].default).to eq(nil)

        expect(props[10].mapping_name).to eq('typeArrayWithItems')
        expect(props[10].type).to be_a(Shale::Schema::Compiler::String)
        expect(props[10].collection?).to eq(true)
        expect(props[10].default).to eq(nil)

        expect(props[11].mapping_name).to eq('typeArrayWithoutItems')
        expect(props[11].type).to be_a(Shale::Schema::Compiler::Value)
        expect(props[11].collection?).to eq(true)
        expect(props[11].default).to eq(nil)

        expect(props[12].mapping_name).to eq('schemaTrue')
        expect(props[12].type).to be_a(Shale::Schema::Compiler::Value)
        expect(props[12].collection?).to eq(false)
        expect(props[12].default).to eq(nil)

        expect(props[13].mapping_name).to eq('address')
        expect(props[13].type).to be_a(Shale::Schema::Compiler::Complex)
        expect(props[13].type.name).to eq('Address1')
        expect(props[13].collection?).to eq(false)
        expect(props[13].default).to eq(nil)

        expect(props[14].mapping_name).to eq('shipping')
        expect(props[14].type).to be_a(Shale::Schema::Compiler::Complex)
        expect(props[14].type.name).to eq('Address2')
        expect(props[14].collection?).to eq(false)
        expect(props[14].default).to eq(nil)

        expect(props[15].mapping_name).to eq('billing')
        expect(props[15].type).to be_a(Shale::Schema::Compiler::Complex)
        expect(props[15].type.name).to eq('Address2')
        expect(props[15].collection?).to eq(false)
        expect(props[15].default).to eq(nil)

        expect(props[16].mapping_name).to eq('mailing')
        expect(props[16].type).to be_a(Shale::Schema::Compiler::String)
        expect(props[16].collection?).to eq(false)
        expect(props[16].default).to eq(nil)
      end
    end

    context 'with circular dependency' do
      let(:schema) do
        <<~DATA
          {
            "$ref": "#/$defs/a",
            "$defs": {
              "a": {
                "type": "object",
                "properties": {
                  "a": { "$ref": "#/$defs/a" },
                  "b": { "$ref": "#/$defs/b" }
                }
              },
              "b": {
                "type": "object",
                "properties": {
                  "a": { "$ref": "#/$defs/a" }
                }
              }
            }
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema])

        expect(models.length).to eq(2)

        expect(models[0].id).to eq('#/$defs/b')
        expect(models[0].name).to eq('B')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('a')
        expect(models[0].properties[0].type.name).to eq('A')

        expect(models[1].id).to eq('#/$defs/a')
        expect(models[1].name).to eq('A')
        expect(models[1].properties.length).to eq(2)
        expect(models[1].properties[0].mapping_name).to eq('a')
        expect(models[1].properties[0].type.name).to eq('A')
        expect(models[1].properties[1].mapping_name).to eq('b')
        expect(models[1].properties[1].type.name).to eq('B')
      end
    end

    context 'when root has no name and root_name is not provided' do
      let(:schema) do
        <<~DATA
          {
            "type": "object"
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema])
        expect(models[0].name).to eq('Root')
      end
    end

    context 'when root has no name and root_name is provided' do
      let(:schema) do
        <<~DATA
          {
            "type": "object"
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema], root_name: 'foo')
        expect(models[0].name).to eq('Foo')
      end
    end

    context 'when root has name and root_name is not provided' do
      let(:schema) do
        <<~DATA
          {
            "$ref": "#/$defs/bar",
            "$defs": {
              "bar": {
                "type": "object"
              }
            }
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema])
        expect(models[0].name).to eq('Bar')
      end
    end

    context 'when root has name and root_name is provided' do
      let(:schema) do
        <<~DATA
          {
            "$ref": "#/$defs/bar",
            "$defs": {
              "bar": {
                "type": "object"
              }
            }
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema], root_name: 'Foo')
        expect(models[0].name).to eq('Foo')
      end
    end
  end

  describe '#to_schema' do
    let(:schema) do
      <<~DATA
        {
          "type": "object",
          "properties": {
            "name": { "type": "string" }
          }
        }
      DATA
    end

    let(:result) do
      <<~DATA
        require 'shale'

        class Root < Shale::Mapper
          attribute :name, Shale::Type::String

          json do
            map 'name', to: :name
          end
        end
      DATA
    end

    it 'genrates output' do
      models = described_class.new.to_models([schema])

      expect(models).to eq({ 'root' => result })
    end
  end
end
