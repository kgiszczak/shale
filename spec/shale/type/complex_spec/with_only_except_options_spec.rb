# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__OnlyExceptOptions # rubocop:disable Naming/ClassAndModuleCamelCase
  class Street < Shale::Mapper
    attribute :name, Shale::Type::String
    attribute :house_no, Shale::Type::String
    attribute :flat_no, Shale::Type::String

    xml do
      root 'Street'

      map_content to: :name
      map_attribute 'house_no', to: :house_no
      map_element 'FlatNo', to: :flat_no
    end
  end

  class Address < Shale::Mapper
    attribute :city, Shale::Type::String
    attribute :zip, Shale::Type::String
    attribute :street, Street

    xml do
      root 'Address'

      map_content to: :city
      map_attribute 'zip', to: :zip
      map_element 'Street', to: :street
    end
  end

  class Car < Shale::Mapper
    attribute :brand, Shale::Type::String
    attribute :model, Shale::Type::String
    attribute :engine, Shale::Type::String

    xml do
      root 'Car'

      map_content to: :brand
      map_attribute 'engine', to: :engine
      map_element 'Model', to: :model
    end
  end

  class Person < Shale::Mapper
    attribute :first_name, Shale::Type::String
    attribute :last_name, Shale::Type::String
    attribute :age, Shale::Type::Integer
    attribute :address, Address
    attribute :car, Car, collection: true

    csv do
      map 'first_name', to: :first_name
      map 'last_name', to: :last_name
      map 'age', to: :age
    end

    xml do
      root 'Person'

      map_content to: :first_name
      map_attribute 'age', to: :age
      map_element 'LastName', to: :last_name
      map_element 'Address', to: :address
      map_element 'Car', to: :car
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

  context 'with only/except options' do
    let(:mapper) { ComplexSpec__OnlyExceptOptions::Person }

    context 'with hash mapping' do
      let(:hash) do
        {
          'first_name' => 'John',
          'last_name' => 'Doe',
          'age' => 44,
          'address' => {
            'city' => 'London',
            'zip' => '1N ASD123',
            'street' => {
              'name' => 'Oxford Street', 'house_no' => '1', 'flat_no' => '2'
            },
          },
          'car' => [
            { 'brand' => 'Honda', 'model' => 'Accord', 'engine' => '1.4' },
            { 'brand' => 'Toyota', 'model' => 'Corolla', 'engine' => '2.0' },
          ],
        }
      end

      let(:hash_collection) do
        [
          {
            'first_name' => 'John',
            'last_name' => 'Doe',
            'age' => 44,
            'address' => {
              'city' => 'London',
              'zip' => '1N ASD123',
              'street' => {
                'name' => 'Oxford Street', 'house_no' => '1', 'flat_no' => '2'
              },
            },
            'car' => [
              { 'brand' => 'Honda', 'model' => 'Accord', 'engine' => '1.4' },
              { 'brand' => 'Toyota', 'model' => 'Corolla', 'engine' => '2.0' },
            ],
          },
          {
            'first_name' => 'John',
            'last_name' => 'Doe',
            'age' => 44,
            'address' => {
              'city' => 'London',
              'zip' => '1N ASD123',
              'street' => {
                'name' => 'Oxford Street', 'house_no' => '1', 'flat_no' => '2'
              },
            },
            'car' => [
              { 'brand' => 'Honda', 'model' => 'Accord', 'engine' => '1.4' },
              { 'brand' => 'Toyota', 'model' => 'Corolla', 'engine' => '2.0' },
            ],
          },
        ]
      end

      describe '.from_hash' do
        it 'maps hash to partial object' do
          instance = mapper.from_hash(
            hash,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_hash(
            hash,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end

        it 'maps collection to partial object' do
          instance = mapper.from_hash(
            hash_collection,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq('John')
            expect(instance[i].last_name).to eq(nil)
            expect(instance[i].age).to eq(nil)
            expect(instance[i].address.city).to eq(nil)
            expect(instance[i].address.zip).to eq('1N ASD123')
            expect(instance[i].address.street.name).to eq(nil)
            expect(instance[i].address.street.house_no).to eq(nil)
            expect(instance[i].address.street.flat_no).to eq('2')
            expect(instance[i].car[0].brand).to eq(nil)
            expect(instance[i].car[0].model).to eq('Accord')
            expect(instance[i].car[0].engine).to eq(nil)
            expect(instance[i].car[1].brand).to eq(nil)
            expect(instance[i].car[1].model).to eq('Corolla')
            expect(instance[i].car[1].engine).to eq(nil)
          end

          instance = mapper.from_hash(
            hash_collection,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq(nil)
            expect(instance[i].last_name).to eq('Doe')
            expect(instance[i].age).to eq(44)
            expect(instance[i].address.city).to eq('London')
            expect(instance[i].address.zip).to eq(nil)
            expect(instance[i].address.street.name).to eq('Oxford Street')
            expect(instance[i].address.street.house_no).to eq('1')
            expect(instance[i].address.street.flat_no).to eq(nil)
            expect(instance[i].car[0].brand).to eq('Honda')
            expect(instance[i].car[0].model).to eq(nil)
            expect(instance[i].car[0].engine).to eq('1.4')
            expect(instance[i].car[1].brand).to eq('Toyota')
            expect(instance[i].car[1].model).to eq(nil)
            expect(instance[i].car[1].engine).to eq('2.0')
          end
        end
      end

      describe '.to_hash' do
        it 'converts objects to partial hash' do
          instance = mapper.from_hash(hash)

          result = instance.to_hash(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq({
            'first_name' => 'John',
            'address' => {
              'zip' => '1N ASD123',
              'street' => { 'flat_no' => '2' },
            },
            'car' => [
              { 'model' => 'Accord' },
              { 'model' => 'Corolla' },
            ],
          })

          result = instance.to_hash(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq({
            'last_name' => 'Doe',
            'age' => 44,
            'address' => {
              'city' => 'London',
              'street' => { 'name' => 'Oxford Street', 'house_no' => '1' },
            },
            'car' => [
              { 'brand' => 'Honda', 'engine' => '1.4' },
              { 'brand' => 'Toyota', 'engine' => '2.0' },
            ],
          })
        end

        it 'converts array to partial hash' do
          instance = mapper.from_hash(hash_collection)

          result = mapper.to_hash(
            instance,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(
            [
              {
                'first_name' => 'John',
                'address' => {
                  'zip' => '1N ASD123',
                  'street' => { 'flat_no' => '2' },
                },
                'car' => [
                  { 'model' => 'Accord' },
                  { 'model' => 'Corolla' },
                ],
              },
              {
                'first_name' => 'John',
                'address' => {
                  'zip' => '1N ASD123',
                  'street' => { 'flat_no' => '2' },
                },
                'car' => [
                  { 'model' => 'Accord' },
                  { 'model' => 'Corolla' },
                ],
              },
            ]
          )

          result = mapper.to_hash(
            instance,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(
            [
              {
                'last_name' => 'Doe',
                'age' => 44,
                'address' => {
                  'city' => 'London',
                  'street' => { 'name' => 'Oxford Street', 'house_no' => '1' },
                },
                'car' => [
                  { 'brand' => 'Honda', 'engine' => '1.4' },
                  { 'brand' => 'Toyota', 'engine' => '2.0' },
                ],
              },
              {
                'last_name' => 'Doe',
                'age' => 44,
                'address' => {
                  'city' => 'London',
                  'street' => { 'name' => 'Oxford Street', 'house_no' => '1' },
                },
                'car' => [
                  { 'brand' => 'Honda', 'engine' => '1.4' },
                  { 'brand' => 'Toyota', 'engine' => '2.0' },
                ],
              },
            ]
          )
        end
      end
    end

    context 'with JSON mapping' do
      let(:json) do
        <<~DOC
          {
            "first_name": "John",
            "last_name": "Doe",
            "age": 44,
            "hobby": [
              "Singing",
              "Dancing"
            ],
            "address": {
              "city": "London",
              "zip": "1N ASD123",
              "street": {
                "name": "Oxford Street",
                "house_no": "1",
                "flat_no": "2"
              }
            },
            "car": [
              {
                "brand": "Honda",
                "model": "Accord",
                "engine": "1.4"
              },
              {
                "brand": "Toyota",
                "model": "Corolla",
                "engine": "2.0"
              }
            ]
          }
        DOC
      end

      let(:json_collection) do
        <<~DOC
          [
            {
              "first_name": "John",
              "last_name": "Doe",
              "age": 44,
              "hobby": [
                "Singing",
                "Dancing"
              ],
              "address": {
                "city": "London",
                "zip": "1N ASD123",
                "street": {
                  "name": "Oxford Street",
                  "house_no": "1",
                  "flat_no": "2"
                }
              },
              "car": [
                {
                  "brand": "Honda",
                  "model": "Accord",
                  "engine": "1.4"
                },
                {
                  "brand": "Toyota",
                  "model": "Corolla",
                  "engine": "2.0"
                }
              ]
            },
            {
              "first_name": "John",
              "last_name": "Doe",
              "age": 44,
              "hobby": [
                "Singing",
                "Dancing"
              ],
              "address": {
                "city": "London",
                "zip": "1N ASD123",
                "street": {
                  "name": "Oxford Street",
                  "house_no": "1",
                  "flat_no": "2"
                }
              },
              "car": [
                {
                  "brand": "Honda",
                  "model": "Accord",
                  "engine": "1.4"
                },
                {
                  "brand": "Toyota",
                  "model": "Corolla",
                  "engine": "2.0"
                }
              ]
            }
          ]
        DOC
      end

      describe '.from_json' do
        it 'maps JSON to partial object' do
          instance = mapper.from_json(
            json,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_json(
            json,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end

        it 'maps JSON collection to partial object' do
          instance = mapper.from_json(
            json_collection,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq('John')
            expect(instance[i].last_name).to eq(nil)
            expect(instance[i].age).to eq(nil)
            expect(instance[i].address.city).to eq(nil)
            expect(instance[i].address.zip).to eq('1N ASD123')
            expect(instance[i].address.street.name).to eq(nil)
            expect(instance[i].address.street.house_no).to eq(nil)
            expect(instance[i].address.street.flat_no).to eq('2')
            expect(instance[i].car[0].brand).to eq(nil)
            expect(instance[i].car[0].model).to eq('Accord')
            expect(instance[i].car[0].engine).to eq(nil)
            expect(instance[i].car[1].brand).to eq(nil)
            expect(instance[i].car[1].model).to eq('Corolla')
            expect(instance[i].car[1].engine).to eq(nil)
          end

          instance = mapper.from_json(
            json_collection,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq(nil)
            expect(instance[i].last_name).to eq('Doe')
            expect(instance[i].age).to eq(44)
            expect(instance[i].address.city).to eq('London')
            expect(instance[i].address.zip).to eq(nil)
            expect(instance[i].address.street.name).to eq('Oxford Street')
            expect(instance[i].address.street.house_no).to eq('1')
            expect(instance[i].address.street.flat_no).to eq(nil)
            expect(instance[i].car[0].brand).to eq('Honda')
            expect(instance[i].car[0].model).to eq(nil)
            expect(instance[i].car[0].engine).to eq('1.4')
            expect(instance[i].car[1].brand).to eq('Toyota')
            expect(instance[i].car[1].model).to eq(nil)
            expect(instance[i].car[1].engine).to eq('2.0')
          end
        end
      end

      describe '.to_json' do
        it 'converts objects to partial JSON' do
          instance = mapper.from_json(json)

          result = instance.to_json(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            {
              "first_name": "John",
              "address": {
                "zip": "1N ASD123",
                "street": {
                  "flat_no": "2"
                }
              },
              "car": [
                {
                  "model": "Accord"
                },
                {
                  "model": "Corolla"
                }
              ]
            }
          DOC

          result = instance.to_json(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            {
              "last_name": "Doe",
              "age": 44,
              "address": {
                "city": "London",
                "street": {
                  "name": "Oxford Street",
                  "house_no": "1"
                }
              },
              "car": [
                {
                  "brand": "Honda",
                  "engine": "1.4"
                },
                {
                  "brand": "Toyota",
                  "engine": "2.0"
                }
              ]
            }
          DOC
        end

        it 'converts array to partial JSON' do
          instance = mapper.from_json(json_collection)

          result = mapper.to_json(
            instance,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            [
              {
                "first_name": "John",
                "address": {
                  "zip": "1N ASD123",
                  "street": {
                    "flat_no": "2"
                  }
                },
                "car": [
                  {
                    "model": "Accord"
                  },
                  {
                    "model": "Corolla"
                  }
                ]
              },
              {
                "first_name": "John",
                "address": {
                  "zip": "1N ASD123",
                  "street": {
                    "flat_no": "2"
                  }
                },
                "car": [
                  {
                    "model": "Accord"
                  },
                  {
                    "model": "Corolla"
                  }
                ]
              }
            ]
          DOC

          result = mapper.to_json(
            instance,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            [
              {
                "last_name": "Doe",
                "age": 44,
                "address": {
                  "city": "London",
                  "street": {
                    "name": "Oxford Street",
                    "house_no": "1"
                  }
                },
                "car": [
                  {
                    "brand": "Honda",
                    "engine": "1.4"
                  },
                  {
                    "brand": "Toyota",
                    "engine": "2.0"
                  }
                ]
              },
              {
                "last_name": "Doe",
                "age": 44,
                "address": {
                  "city": "London",
                  "street": {
                    "name": "Oxford Street",
                    "house_no": "1"
                  }
                },
                "car": [
                  {
                    "brand": "Honda",
                    "engine": "1.4"
                  },
                  {
                    "brand": "Toyota",
                    "engine": "2.0"
                  }
                ]
              }
            ]
          DOC
        end
      end
    end

    context 'with YAML mapping' do
      let(:yaml) do
        <<~DOC
          ---
          first_name: John
          last_name: Doe
          age: 44
          hobby:
          - Singing
          - Dancing
          address:
            city: London
            zip: 1N ASD123
            street:
              name: Oxford Street
              house_no: '1'
              flat_no: '2'
          car:
          - brand: Honda
            model: Accord
            engine: '1.4'
          - brand: Toyota
            model: Corolla
            engine: '2.0'
        DOC
      end

      let(:yaml_collection) do
        <<~DOC
          ---
          - first_name: John
            last_name: Doe
            age: 44
            hobby:
            - Singing
            - Dancing
            address:
              city: London
              zip: 1N ASD123
              street:
                name: Oxford Street
                house_no: '1'
                flat_no: '2'
            car:
            - brand: Honda
              model: Accord
              engine: '1.4'
            - brand: Toyota
              model: Corolla
              engine: '2.0'
          - first_name: John
            last_name: Doe
            age: 44
            hobby:
            - Singing
            - Dancing
            address:
              city: London
              zip: 1N ASD123
              street:
                name: Oxford Street
                house_no: '1'
                flat_no: '2'
            car:
            - brand: Honda
              model: Accord
              engine: '1.4'
            - brand: Toyota
              model: Corolla
              engine: '2.0'
        DOC
      end

      describe '.from_yaml' do
        it 'maps YAML to partial object' do
          instance = mapper.from_yaml(
            yaml,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_yaml(
            yaml,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end

        it 'maps YAML collection to partial object' do
          instance = mapper.from_yaml(
            yaml_collection,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq('John')
            expect(instance[i].last_name).to eq(nil)
            expect(instance[i].age).to eq(nil)
            expect(instance[i].address.city).to eq(nil)
            expect(instance[i].address.zip).to eq('1N ASD123')
            expect(instance[i].address.street.name).to eq(nil)
            expect(instance[i].address.street.house_no).to eq(nil)
            expect(instance[i].address.street.flat_no).to eq('2')
            expect(instance[i].car[0].brand).to eq(nil)
            expect(instance[i].car[0].model).to eq('Accord')
            expect(instance[i].car[0].engine).to eq(nil)
            expect(instance[i].car[1].brand).to eq(nil)
            expect(instance[i].car[1].model).to eq('Corolla')
            expect(instance[i].car[1].engine).to eq(nil)
          end

          instance = mapper.from_yaml(
            yaml_collection,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          2.times do |i|
            expect(instance[i].first_name).to eq(nil)
            expect(instance[i].last_name).to eq('Doe')
            expect(instance[i].age).to eq(44)
            expect(instance[i].address.city).to eq('London')
            expect(instance[i].address.zip).to eq(nil)
            expect(instance[i].address.street.name).to eq('Oxford Street')
            expect(instance[i].address.street.house_no).to eq('1')
            expect(instance[i].address.street.flat_no).to eq(nil)
            expect(instance[i].car[0].brand).to eq('Honda')
            expect(instance[i].car[0].model).to eq(nil)
            expect(instance[i].car[0].engine).to eq('1.4')
            expect(instance[i].car[1].brand).to eq('Toyota')
            expect(instance[i].car[1].model).to eq(nil)
            expect(instance[i].car[1].engine).to eq('2.0')
          end
        end
      end

      describe '.to_yaml' do
        it 'converts objects to partial YAML' do
          instance = mapper.from_yaml(yaml)

          result = instance.to_yaml(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            first_name: John
            address:
              zip: 1N ASD123
              street:
                flat_no: '2'
            car:
            - model: Accord
            - model: Corolla
          DOC

          result = instance.to_yaml(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            last_name: Doe
            age: 44
            address:
              city: London
              street:
                name: Oxford Street
                house_no: '1'
            car:
            - brand: Honda
              engine: '1.4'
            - brand: Toyota
              engine: '2.0'
          DOC
        end

        it 'converts array to partial YAML' do
          instance = mapper.from_yaml(yaml_collection)

          result = mapper.to_yaml(
            instance,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            - first_name: John
              address:
                zip: 1N ASD123
                street:
                  flat_no: '2'
              car:
              - model: Accord
              - model: Corolla
            - first_name: John
              address:
                zip: 1N ASD123
                street:
                  flat_no: '2'
              car:
              - model: Accord
              - model: Corolla
          DOC

          result = mapper.to_yaml(
            instance,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            ---
            - last_name: Doe
              age: 44
              address:
                city: London
                street:
                  name: Oxford Street
                  house_no: '1'
              car:
              - brand: Honda
                engine: '1.4'
              - brand: Toyota
                engine: '2.0'
            - last_name: Doe
              age: 44
              address:
                city: London
                street:
                  name: Oxford Street
                  house_no: '1'
              car:
              - brand: Honda
                engine: '1.4'
              - brand: Toyota
                engine: '2.0'
          DOC
        end
      end
    end

    context 'with TOML mapping' do
      let(:toml) do
        <<~DOC
          first_name = "John"
          last_name = "Doe"
          age = 44
          hobby = [ "Singing", "Dancing" ]

          [address]
          city = "London"
          zip = "1N ASD123"

            [address.street]
            name = "Oxford Street"
            house_no = "1"
            flat_no = "2"

          [[car]]
          brand = "Honda"
          model = "Accord"
          engine = "1.4"

          [[car]]
          brand = "Toyota"
          model = "Corolla"
          engine = "2.0"
        DOC
      end

      describe '.from_toml' do
        it 'maps TOML to partial object' do
          instance = mapper.from_toml(
            toml,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq('John')
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_toml(
            toml,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq('London')
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq('Oxford Street')
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq('Honda')
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq('Toyota')
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end
      end

      describe '.to_toml' do
        it 'converts objects to partial TOML' do
          instance = mapper.from_toml(toml)

          result = instance.to_toml(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            first_name = "John"

            [address]
            zip = "1N ASD123"

              [address.street]
              flat_no = "2"

            [[car]]
            model = "Accord"

            [[car]]
            model = "Corolla"
          DOC

          result = instance.to_toml(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(result).to eq(<<~DOC)
            last_name = "Doe"
            age = 44

            [address]
            city = "London"

              [address.street]
              name = "Oxford Street"
              house_no = "1"

            [[car]]
            brand = "Honda"
            engine = "1.4"

            [[car]]
            brand = "Toyota"
            engine = "2.0"
          DOC
        end
      end
    end

    context 'with CSV mapping' do
      let(:csv) do
        <<~DOC
          first_name,last_name,age
          John,Doe,44
        DOC
      end

      let(:csv_collection) do
        <<~DOC
          first_name,last_name,age
          John,Doe,44
          John,Doe,44
        DOC
      end

      describe '.from_csv' do
        it 'maps CSV to partial object' do
          instance = mapper.from_csv(csv, only: [:first_name], headers: true)
          expect(instance[0].first_name).to eq('John')
          expect(instance[0].last_name).to eq(nil)
          expect(instance[0].age).to eq(nil)

          instance = mapper.from_csv(csv, except: [:first_name], headers: true)
          expect(instance[0].first_name).to eq(nil)
          expect(instance[0].last_name).to eq('Doe')
          expect(instance[0].age).to eq(44)
        end

        it 'maps CSV collection to partial object' do
          instance = mapper.from_csv(csv_collection, only: [:first_name], headers: true)
          2.times do |i|
            expect(instance[i].first_name).to eq('John')
            expect(instance[i].last_name).to eq(nil)
            expect(instance[i].age).to eq(nil)
          end

          instance = mapper.from_csv(csv_collection, except: [:first_name], headers: true)
          2.times do |i|
            expect(instance[i].first_name).to eq(nil)
            expect(instance[i].last_name).to eq('Doe')
            expect(instance[i].age).to eq(44)
          end
        end
      end

      describe '.to_csv' do
        it 'converts objects to partial CSV' do
          instance = mapper.from_csv(csv, headers: true)

          result = mapper.to_csv(instance, only: [:first_name], headers: true)
          expect(result).to eq("first_name\nJohn\n")

          result = mapper.to_csv(instance, except: [:first_name], headers: true)
          expect(result).to eq("last_name,age\nDoe,44\n")
        end

        it 'converts array to partial CSV' do
          instance = mapper.from_csv(csv_collection, headers: true)

          result = mapper.to_csv(instance, only: [:first_name], headers: true)
          expect(result).to eq(<<~DOC)
            first_name
            John
            John
          DOC

          result = mapper.to_csv(instance, except: [:first_name], headers: true)
          expect(result).to eq(<<~DOC)
            last_name,age
            Doe,44
            Doe,44
          DOC
        end
      end
    end

    context 'with XML mapping' do
      let(:xml) do
        <<~DOC
          <Person age="44">
            John
            <LastName>Doe</LastName>
            <Hobby>Singing</Hobby>
            <Hobby>Dancing</Hobby>
            <Address zip="1N ASD123">
              London
              <Street house_no="1">
                Oxford Street
                <FlatNo>2</FlatNo>
              </Street>
            </Address>
            <Car engine="1.4">
              Honda
              <Model>Accord</Model>
            </Car>
            <Car engine="2.0">
              Toyota
              <Model>Corolla</Model>
            </Car>
          </Person>
        DOC
      end

      describe '.from_xml' do
        it 'maps XML to partial object' do
          instance = mapper.from_xml(
            xml,
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq("\n  John\n  ")
          expect(instance.last_name).to eq(nil)
          expect(instance.age).to eq(nil)
          expect(instance.address.city).to eq(nil)
          expect(instance.address.zip).to eq('1N ASD123')
          expect(instance.address.street.name).to eq(nil)
          expect(instance.address.street.house_no).to eq(nil)
          expect(instance.address.street.flat_no).to eq('2')
          expect(instance.car[0].brand).to eq(nil)
          expect(instance.car[0].model).to eq('Accord')
          expect(instance.car[0].engine).to eq(nil)
          expect(instance.car[1].brand).to eq(nil)
          expect(instance.car[1].model).to eq('Corolla')
          expect(instance.car[1].engine).to eq(nil)

          instance = mapper.from_xml(
            xml,
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ]
          )
          expect(instance.first_name).to eq(nil)
          expect(instance.last_name).to eq('Doe')
          expect(instance.age).to eq(44)
          expect(instance.address.city).to eq("\n    London\n    ")
          expect(instance.address.zip).to eq(nil)
          expect(instance.address.street.name).to eq("\n      Oxford Street\n      ")
          expect(instance.address.street.house_no).to eq('1')
          expect(instance.address.street.flat_no).to eq(nil)
          expect(instance.car[0].brand).to eq("\n    Honda\n    ")
          expect(instance.car[0].model).to eq(nil)
          expect(instance.car[0].engine).to eq('1.4')
          expect(instance.car[1].brand).to eq("\n    Toyota\n    ")
          expect(instance.car[1].model).to eq(nil)
          expect(instance.car[1].engine).to eq('2.0')
        end
      end

      describe '.to_xml' do
        it 'converts objects to partial XML' do
          instance = mapper.from_xml(xml)
          instance.first_name = instance.first_name.strip
          instance.address.city = instance.address.city.strip
          instance.address.street.name = instance.address.street.name.strip
          instance.car[0].brand = instance.car[0].brand.strip
          instance.car[1].brand = instance.car[1].brand.strip

          result = instance.to_xml(
            only: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            <Person>
              John
              <Address zip="1N ASD123">
                <Street>
                  <FlatNo>2</FlatNo>
                </Street>
              </Address>
              <Car>
                <Model>Accord</Model>
              </Car>
              <Car>
                <Model>Corolla</Model>
              </Car>
            </Person>
          DOC

          result = instance.to_xml(
            except: [
              :first_name,
              { address: [:zip, { street: [:flat_no] }] },
              { car: [:model] },
            ],
            pretty: true
          )
          expect(result).to eq(<<~DOC.gsub(/\n\z/, ''))
            <Person age="44">
              <LastName>Doe</LastName>
              <Address>
                London
                <Street house_no="1">Oxford Street</Street>
              </Address>
              <Car engine="1.4">Honda</Car>
              <Car engine="2.0">Toyota</Car>
            </Person>
          DOC
        end
      end
    end
  end
end
