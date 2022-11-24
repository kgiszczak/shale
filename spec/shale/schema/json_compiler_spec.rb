# frozen_string_literal: true

require 'shale/adapter/json'
require 'shale/schema/json_compiler'

RSpec.describe Shale::Schema::JSONCompiler do
  before(:each) do
    Shale.json_adapter = Shale::Adapter::JSON
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
        end.to raise_error(Shale::SchemaError, "schema with id 'foo' already exists")
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
        end.to raise_error(Shale::SchemaError, "can't resolve reference '#/$defs/bar'")
      end
    end

    context 'with correct schema' do
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

    context 'with bundled schema' do
      let(:schema) do
        <<~DATA
          {
            "$id": "https://foo.bar/schemas/common",

            "type": "object",
            "properties": {
              "first_name": { "type": "string" },
              "last_name": { "type": "string" },
              "address": { "$ref": "#/$defs/address" },
              "car": { "$ref": "https://foo.bar/schemas/ext" }
            },
            "$defs": {
              "address": {
                "type": "object",
                "properties": {
                  "street": { "type": "string" },
                  "city": { "type": "string" }
                }
              },
              "car": {
                "$id": "https://foo.bar/schemas/ext",

                "type": "object",
                "properties": {
                  "brand": { "type": "string" },
                  "model": { "type": "string" },
                  "manufacturer": { "$ref": "#/$defs/manufacturer" }
                },
                "$defs": {
                  "manufacturer": {
                    "type": "object",
                    "properties": {
                      "name": { "type": "string" }
                    }
                  }
                }
              }
            }
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema])

        expect(models.length).to eq(4)

        expect(models[0].id).to eq('https://foo.bar/schemas/ext#/$defs/manufacturer')
        expect(models[0].name).to eq('Manufacturer')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('name')

        expect(models[1].id).to eq('https://foo.bar/schemas/ext')
        expect(models[1].name).to eq('Car')
        expect(models[1].properties.length).to eq(3)
        expect(models[1].properties[0].mapping_name).to eq('brand')
        expect(models[1].properties[1].mapping_name).to eq('model')
        expect(models[1].properties[2].mapping_name).to eq('manufacturer')

        expect(models[2].id).to eq('https://foo.bar/schemas/common#/$defs/address')
        expect(models[2].name).to eq('Address')
        expect(models[2].properties.length).to eq(2)
        expect(models[2].properties[0].mapping_name).to eq('street')
        expect(models[2].properties[1].mapping_name).to eq('city')

        expect(models[3].id).to eq('https://foo.bar/schemas/common')
        expect(models[3].name).to eq('Root')
        expect(models[3].properties.length).to eq(4)
        expect(models[3].properties[0].mapping_name).to eq('first_name')
        expect(models[3].properties[1].mapping_name).to eq('last_name')
        expect(models[3].properties[2].mapping_name).to eq('address')
        expect(models[3].properties[3].mapping_name).to eq('car')
      end
    end

    context 'with bundled schema and references' do
      let(:schema) do
        <<~DATA
          {
            "$id": "https://foo.bar/schemas/common",

            "$ref": "#/$defs/person",
            "$defs": {
              "person": {
                "type": "object",
                "properties": {
                  "first_name": { "type": "string" },
                  "last_name": { "type": "string" },
                  "address": { "$ref": "#/$defs/address" },
                  "car": { "$ref": "https://foo.bar/schemas/ext" }
                }
              },
              "address": {
                "type": "object",
                "properties": {
                  "street": { "type": "string" },
                  "city": { "type": "string" }
                }
              },
              "car": {
                "$id": "https://foo.bar/schemas/ext",

                "type": "object",
                "properties": {
                  "brand": { "type": "string" },
                  "model": { "type": "string" },
                  "manufacturer": { "$ref": "#/$defs/manufacturer" }
                },
                "$defs": {
                  "manufacturer": {
                    "type": "object",
                    "properties": {
                      "name": { "type": "string" }
                    }
                  }
                }
              }
            }
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema])

        expect(models.length).to eq(4)

        expect(models[0].id).to eq('https://foo.bar/schemas/ext#/$defs/manufacturer')
        expect(models[0].name).to eq('Manufacturer')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('name')

        expect(models[1].id).to eq('https://foo.bar/schemas/ext')
        expect(models[1].name).to eq('Car')
        expect(models[1].properties.length).to eq(3)
        expect(models[1].properties[0].mapping_name).to eq('brand')
        expect(models[1].properties[1].mapping_name).to eq('model')
        expect(models[1].properties[2].mapping_name).to eq('manufacturer')

        expect(models[2].id).to eq('https://foo.bar/schemas/common#/$defs/address')
        expect(models[2].name).to eq('Address')
        expect(models[2].properties.length).to eq(2)
        expect(models[2].properties[0].mapping_name).to eq('street')
        expect(models[2].properties[1].mapping_name).to eq('city')

        expect(models[3].id).to eq('https://foo.bar/schemas/common#/$defs/person')
        expect(models[3].name).to eq('Person')
        expect(models[3].properties.length).to eq(4)
        expect(models[3].properties[0].mapping_name).to eq('first_name')
        expect(models[3].properties[1].mapping_name).to eq('last_name')
        expect(models[3].properties[2].mapping_name).to eq('address')
        expect(models[3].properties[3].mapping_name).to eq('car')
      end
    end

    context 'with bundled schema and nested properties' do
      let(:schema) do
        <<~DATA
          {
            "$id": "https://foo.bar/schemas/common",

            "type": "object",
            "properties": {
              "name": { "type": "string" },
              "address": { "$ref": "https://foo.bar/schemas/ext#/$defs/address" }
            },
            "$defs": {
              "car": {
                "$id": "https://foo.bar/schemas/ext",

                "type": "object",
                "$defs": {
                  "address": {
                    "type": "object",
                    "properties": {
                      "street": {
                        "type": "object",
                        "properties": {
                          "name": { "type": "string" }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        DATA
      end

      it 'generates Shale models' do
        models = described_class.new.as_models([schema])

        expect(models.length).to eq(3)

        expect(models[0].id).to eq('https://foo.bar/schemas/ext#/$defs/address/properties/street')
        expect(models[0].name).to eq('Street')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('name')

        expect(models[1].id).to eq('https://foo.bar/schemas/ext#/$defs/address')
        expect(models[1].name).to eq('Address')
        expect(models[1].properties.length).to eq(1)
        expect(models[1].properties[0].mapping_name).to eq('street')

        expect(models[2].id).to eq('https://foo.bar/schemas/common')
        expect(models[2].name).to eq('Root')
        expect(models[2].properties.length).to eq(2)
        expect(models[2].properties[0].mapping_name).to eq('name')
        expect(models[2].properties[1].mapping_name).to eq('address')
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

    context 'with duplicated names' do
      let(:schema) do
        <<~SCHEMA
          {
            "type": "object",
            "properties": {
              "home": {
                "type": "object",
                "properties": {
                  "address": { "type": "object" }
                }
              },
              "work": {
                "type": "object",
                "properties": {
                  "address": { "type": "object" }
                }
              }
            }
          }
        SCHEMA
      end

      it 'generates models' do
        models = described_class.new.as_models([schema])

        expect(models.length).to eq(5)

        expect(models[0].name).to eq('Address2')
        expect(models[1].name).to eq('Work')
        expect(models[2].name).to eq('Address1')
        expect(models[3].name).to eq('Home')
        expect(models[4].name).to eq('Root')
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

    context 'with namespace mapping' do
      context 'without id' do
        let(:schema) do
          <<~SCHEMA
            {
              "$ref": "#/$defs/Person",
              "$defs": {
                "Person": {
                  "type": "object",
                  "properties": {
                    "name": { "type": "string" },
                    "address": { "$ref": "#/$defs/Address" }
                  }
                },
                "Address": {
                  "type": "object",
                  "properties": {
                    "street": { "type": "string" }
                  }
                }
              }
            }
          SCHEMA
        end

        let(:mapping) do
          { nil => 'Foo::Bar' }
        end

        it 'generates models' do
          models = described_class.new.as_models([schema], namespace_mapping: mapping)

          expect(models.length).to eq(2)

          expect(models[0].name).to eq('Foo::Bar::Address')
          expect(models[1].name).to eq('Foo::Bar::Person')
        end
      end

      context 'with ids' do
        let(:schema) do
          <<~SCHEMA
            {
              "$id": "http://foo.com",
              "$ref": "#/$defs/Person",
              "$defs": {
                "Person": {
                  "type": "object",
                  "properties": {
                    "address": { "$ref": "http://bar.com" }
                  }
                },
                "Address": {
                  "$id": "http://bar.com",
                  "type": "object"
                }
              }
            }
          SCHEMA
        end

        let(:mapping) do
          {
            'http://foo.com' => 'Foo',
            'http://bar.com' => 'Bar',
          }
        end

        it 'generates models' do
          models = described_class.new.as_models([schema], namespace_mapping: mapping)

          expect(models.length).to eq(2)

          expect(models[0].name).to eq('Bar::Address')
          expect(models[1].name).to eq('Foo::Person')
        end
      end

      context 'with duplicated names' do
        let(:schema) do
          <<~SCHEMA
            {
              "$id": "http://foo.com",
              "type": "object",
              "properties": {
                "home": {
                  "type": "object",
                  "properties": {
                    "address": { "type": "object" }
                  }
                },
                "work": {
                  "type": "object",
                  "properties": {
                    "address": { "type": "object" }
                  }
                },
                "child": { "$ref": "http://bar.com" }
              },
              "$defs": {
                "Child": {
                  "$id": "http://bar.com",
                  "type": "object",
                  "properties": {
                    "home": {
                      "type": "object",
                      "properties": {
                        "address": { "type": "object" }
                      }
                    },
                    "work": {
                      "type": "object",
                      "properties": {
                        "address": { "type": "object" }
                      }
                    }
                  }
                }
              }
            }
          SCHEMA
        end

        let(:mapping) do
          {
            'http://foo.com' => 'Foo',
            'http://bar.com' => 'Bar',
          }
        end

        it 'generates models' do
          models = described_class.new.as_models([schema], namespace_mapping: mapping)

          expect(models.length).to eq(10)

          expect(models[0].name).to eq('Bar::Address2')
          expect(models[1].name).to eq('Bar::Work')
          expect(models[2].name).to eq('Bar::Address1')
          expect(models[3].name).to eq('Bar::Home')
          expect(models[4].name).to eq('Bar::Child')
          expect(models[5].name).to eq('Foo::Address2')
          expect(models[6].name).to eq('Foo::Work')
          expect(models[7].name).to eq('Foo::Address1')
          expect(models[8].name).to eq('Foo::Home')
          expect(models[9].name).to eq('Foo::Root')
        end
      end
    end
  end

  describe '#to_models' do
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

    context 'with namespace mapping' do
      context 'without ids' do
        let(:schema) do
          <<~SCHEMA
            {
              "$ref": "#/$defs/Person",
              "$defs": {
                "Person": {
                  "type": "object",
                  "properties": {
                    "name": { "type": "string" },
                    "address": { "$ref": "#/$defs/Address" }
                  }
                },
                "Address": {
                  "type": "object",
                  "properties": {
                    "street": { "type": "string" }
                  }
                }
              }
            }
          SCHEMA
        end

        let(:mapping) do
          { nil => 'Foo::Bar' }
        end

        let(:address) do
          <<~DATA
            require 'shale'

            module Foo
              module Bar
                class Address < Shale::Mapper
                  attribute :street, Shale::Type::String

                  json do
                    map 'street', to: :street
                  end
                end
              end
            end
          DATA
        end

        let(:person) do
          <<~DATA
            require 'shale'

            require_relative 'address'

            module Foo
              module Bar
                class Person < Shale::Mapper
                  attribute :name, Shale::Type::String
                  attribute :address, Foo::Bar::Address

                  json do
                    map 'name', to: :name
                    map 'address', to: :address
                  end
                end
              end
            end
          DATA
        end

        it 'genrates output' do
          models = described_class.new.to_models([schema], namespace_mapping: mapping)

          expect(models).to eq({
            'foo/bar/person' => person,
            'foo/bar/address' => address,
          })
        end
      end

      context 'with ids' do
        let(:schema) do
          <<~SCHEMA
            {
              "$id": "http://foo.com",
              "$ref": "#/$defs/Person",
              "$defs": {
                "Person": {
                  "type": "object",
                  "properties": {
                    "name": { "type": "string" },
                    "address": { "$ref": "http://bar.com" }
                  }
                },
                "Address": {
                  "$id": "http://bar.com",
                  "type": "object",
                  "properties": {
                    "street": { "type": "string" }
                  }
                }
              }
            }
          SCHEMA
        end

        let(:mapping) do
          {
            'http://foo.com' => 'Foo',
            'http://bar.com' => 'Bar',
          }
        end

        let(:address) do
          <<~DATA
            require 'shale'

            module Bar
              class Address < Shale::Mapper
                attribute :street, Shale::Type::String

                json do
                  map 'street', to: :street
                end
              end
            end
          DATA
        end

        let(:person) do
          <<~DATA
            require 'shale'

            require_relative '../bar/address'

            module Foo
              class Person < Shale::Mapper
                attribute :name, Shale::Type::String
                attribute :address, Bar::Address

                json do
                  map 'name', to: :name
                  map 'address', to: :address
                end
              end
            end
          DATA
        end

        it 'genrates output' do
          models = described_class.new.to_models([schema], namespace_mapping: mapping)

          expect(models).to eq({
            'foo/person' => person,
            'bar/address' => address,
          })
        end
      end
    end
  end
end
