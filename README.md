# Shale

Shale is a Ruby object mapper and serializer for JSON, YAML and XML.
It allows you to parse JSON, YAML and XML data and convert it into Ruby data structures,
as well as serialize data structures into JSON, YAML or XML.

Documentation with interactive examples is available at [Shale website](https://www.shalerb.org)

## Features

* Convert JSON, YAML and XML to Ruby data model
* Convert Ruby data model to JSON, YAML and XML
* Generate JSON and XML Schema from Ruby models
* Compile JSON and XML Schema into Ruby models
* Out of the box support for JSON, YAML, Nokogiri, REXML and Ox parsers
* Support for custom adapters

## Installation

Shale supports Ruby (MRI) 2.7+

Add this line to your application's Gemfile:

```ruby
gem 'shale'
```

And then execute:

```
$ bundle install
```

Or install it yourself as:

```
$ gem install shale
```

## Contents

* [Simple use case](#user-content-simple-use-case)
* [Creating objects](#creating-objects)
* [Converting JSON to object](#converting-json-to-object)
* [Converting object to JSON](#converting-object-to-json)
* [Converting YAML to object](#converting-yaml-to-object)
* [Converting object to YAML](#converting-object-to-yaml)
* [Converting Hash to object](#converting-hash-to-object)
* [Converting object to Hash](#converting-object-to-hash)
* [Converting XML to object](#converting-xml-to-object)
* [Converting object to XML](#converting-object-to-xml)
* [Mapping JSON keys to object attributes](#mapping-json-keys-to-object-attributes)
* [Mapping YAML keys to object attributes](#mapping-yaml-keys-to-object-attributes)
* [Mapping Hash keys to object attributes](#mapping-hash-keys-to-object-attributes)
* [Mapping XML elements and attributes to object attributes](#mapping-xml-elements-and-attributes-to-object-attributes)
* [Using XML namespaces](#using-xml-namespaces)
* [Using methods to extract and generate data](#using-methods-to-extract-and-generate-data)
* [Pretty printing and XML declaration](#pretty-printing-and-xml-declaration)
* [Supported types](#supported-types)
* [Writing your own type](#writing-your-own-type)
* [Adapters](#adapters)
* [Generating JSON Schema](#generating-json-schema)
* [Compiling JSON Schema into Shale model](#compiling-json-schema-into-shale-model)
* [Generating XML Schema](#generating-xml-schema)
* [Compiling XML Schema into Shale model](#compiling-xml-schema-into-shale-model)

## Usage

### Simple use case

```ruby
require 'shale'

class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
  attribute :zip, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer
  attribute :married, Shale::Type::Boolean, default: -> { false }
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :address, Address
end
```

- `default: -> { 'value' }` - add a default value to attribute (it must be a proc that returns value)
- `collection: true` - indicates that a attribute is a collection

### Creating objects

```ruby
person = Person.new(
  first_name: 'John',
  last_name: 'Doe',
  age: 50,
  hobbies: ['Singing', 'Dancing'],
  address: Address.new(city: 'London', street: 'Oxford Street', zip: 'E1 6AN'),
)
```

### Converting JSON to object

```ruby
person = Person.from_json(<<~DATA)
{
  "first_name": "John",
  "last_name": "Doe",
  "age": 50,
  "married": false,
  "hobbies": ["Singing", "Dancing"],
  "address": {
    "city": "London",
    "street": "Oxford Street",
    "zip": "E1 6AN"
  }
}
DATA

# =>
#
# #<Person:0x00007f9bc3086d60
#  @address=
#   #<Address:0x00007f9bc3086748
#    @city="London",
#    @street="Oxford Street",
#    @zip="E1 6AN">,
#  @age=50,
#  @first_name="John",
#  @hobbies=["Singing", "Dancing"],
#  @last_name="Doe",
#  @married=false>
```

### Converting object to JSON

```ruby
person.to_json

# =>
#
# {
#   "first_name": "John",
#   "last_name": "Doe",
#   "age": 50,
#   "married": false,
#   "hobbies": ["Singing", "Dancing"],
#   "address": {
#     "city": "London",
#     "street": "Oxford Street",
#     "zip": "E1 6AN"
#   }
# }
```

### Converting YAML to object

```ruby
person = Person.from_yaml(<<~DATA)
first_name: John
last_name: Doe
age: 50
married: false
hobbies:
- Singing
- Dancing
address:
  city: London
  street: Oxford Street
  zip: E1 6AN
DATA
```

### Converting object to YAML

```ruby
person.to_yaml

# =>
#
# ---
# first_name: John
# last_name: Doe
# age: 50
# married: false
# hobbies:
# - Singing
# - Dancing
# address:
#   city: London
#   street: Oxford Street
#   zip: E1 6AN
```

### Converting Hash to object

```ruby
person = Person.from_hash(
  'first_name' => 'John',
  'last_name' => 'Doe',
  'age' => 50,
  'married' => false,
  'hobbies' => ['Singing', 'Dancing'],
  'address' => {
    'city'=>'London',
    'street'=>'Oxford Street',
    'zip'=>'E1 6AN'
  },
)
```

### Converting object to Hash

```ruby
person.to_hash

# =>
#
# {
#   "first_name"=>"John",
#   "last_name"=>"Doe",
#   "age"=>50,
#   "married"=>false,
#   "hobbies"=>["Singing", "Dancing"],
#   "address"=>{"city"=>"London", "street"=>"Oxford Street", "zip"=>"E1 6AN"}
# }
 ```

### Converting XML to object

To use XML with Shale you have to set adapter you want to use.
Shale comes with adapters for REXML, Nokogiri and OX parsers.
For details see [Adapters](#adapters) section.

```ruby
require 'shale/adapter/rexml'
Shale.xml_adapter = Shale::Adapter::REXML
```

```ruby
person = Person.from_xml(<<~DATA)
<person>
  <first_name>John</first_name>
  <last_name>Doe</last_name>
  <age>50</age>
  <married>false</married>
  <hobbies>Singing</hobbies>
  <hobbies>Dancing</hobbies>
  <address>
    <city>London</city>
    <street>Oxford Street</street>
    <zip>E1 6AN</zip>
  </address>
</person>
DATA
```

### Converting object to XML

```ruby
person.to_xml

# =>
#
# <person>
#   <first_name>John</first_name>
#   <last_name>Doe</last_name>
#   <age>50</age>
#   <married>false</married>
#   <hobbies>Singing</hobbies>
#   <hobbies>Dancing</hobbies>
#   <address>
#     <city>London</city>
#     <street>Oxford Street</street>
#     <zip>E1 6AN</zip>
#   </address>
# </person>
```

### Mapping JSON keys to object attributes

By default keys are named the same as attributes. To use custom keys use:

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String

  json do
    map 'firstName', to: :first_name
    map 'lastName', to: :last_name
  end
end
```

### Mapping YAML keys to object attributes

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String

  yaml do
    map 'firstName', to: :first_name
    map 'lastName', to: :last_name
  end
end
```

### Mapping Hash keys to object attributes

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String

  hsh do
    map 'firstName', to: :first_name
    map 'lastName', to: :last_name
  end
end
```

### Mapping XML elements and attributes to object attributes

XML is more complicated format than JSON or YAML. To map elements, attributes and content use:

```ruby
class Address < Shale::Mapper
  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String
  attribute :zip, Shale::Type::String

  xml do
    map_content to: :street
    map_element 'City', to: :city
    map_element 'ZIP', to: :zip
  end
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :address, Address

  xml do
    root 'Person'

    map_attribute 'age', to: :age

    map_element 'FirstName', to: :first_name
    map_element 'LastName', to: :last_name
    map_element 'Hobby', to: :hobbies
    map_element 'Address', to: :address
  end
end

person = Person.from_xml(<<~DATA)
<Person age="50">
  <FirstName>John</FirstName>
  <LastName>Doe</LastName>
  <Hobby>Singing</Hobby>
  <Hobby>Dancing</Hobby>
  <Address>
    Oxford Street
    <City>London</City>
    <ZIP>E1 6AN</ZIP>
  </Address>
</person>
DATA
```

- `root` - name of the root element
- `map_element` - map content of element to attribute
- `map_attribute` - map element's attribute to attribute
- `map_content` - map first text node to attribute

### Using XML namespaces

To map namespaced elements and attributes use `namespace` and `prefix` properties on
`map_element` and `map_attribute`

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  xml do
    root 'person'

    map_element 'first_name', to: :first_name, namespace: 'http://ns1.com', prefix: 'ns1'
    map_element 'last_name', to: :last_name, namespace: 'http://ns2.com', prefix: 'ns2'
    map_attribute 'age', to: :age, namespace: 'http://ns2.com', prefix: 'ns2'
  end
end

person = Person.from_xml(<<~DATA)
<person xmlns:ns1="http://ns1.com" xmlns:ns2="http://ns2.com" ns2:age="50">
  <ns1:first_name>John</ns1:first_name>
  <ns2:last_name>Doe</ns2:last_name>
</person>
DATA
```

To define default namespace for all elements use `namespace` declaration
(this will define namespace on elements only, if you want to define namespace on an attribute
explicitly declare it on `map_attribute`).

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :middle_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer
  attribute :hobby, Shale::Type::String

  xml do
    root 'person'
    namespace 'http://ns1.com', 'ns1'

    map_element 'first_name', to: :first_name

    # undeclare namespace on 'middle_name' element
    map_element 'middle_name', to: :middle_name, namespace: nil, prefix: nil

    # overwrite default namespace
    map_element 'last_name', to: :last_name, namespace: 'http://ns2.com', prefix: 'ns2'

    map_attribute 'age', to: :age
    map_attribute 'hobby', to: :hobby, namespace: 'http://ns1.com', prefix: 'ns1'
  end
end

person = Person.from_xml(<<~DATA)
<ns1:person xmlns:ns1="http://ns1.com" xmlns:ns2="http://ns2.com" age="50" ns1:hobby="running">
  <ns1:first_name>John</ns1:first_name>
  <middle_name>Joe</middle_name>
  <ns2:last_name>Doe</ns2:last_name>
</ns1:person>
DATA
```

### Using methods to extract and generate data

If you need full controll over extracting and generating data from/to document,
you can use methods to do so:

```ruby
class Person < Shale::Mapper
  attribute :hobbies, Shale::Type::String, collection: true
  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String

  json do
    map 'hobbies', using: { from: :hobbies_from_json, to: :hobbies_to_json }
    map 'address', using: { from: :address_from_json, to: :address_to_json }
  end

  xml do
    root 'Person'

    map_attribute 'hobbies', using: { from: :hobbies_from_xml, to: :hobbies_to_xml }
    map_element 'Address', using: { from: :address_from_xml, to: :address_to_xml }
  end

  def hobbies_from_json(value)
    self.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_json
    hobbies.join(', ')
  end

  def address_from_json(value)
    self.street = value['street']
    self.city = value['city']
  end

  def address_to_json
    { 'street' => street, 'city' => city }
  end

  def hobbies_from_xml(value)
    self.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_xml(element, doc)
    doc.add_attribute(element, 'hobbies', hobbies.join(', '))
  end

  def address_from_xml(node)
    self.street = node.children.find { |e| e.name == 'Street' }.text
    self.city = node.children.find { |e| e.name == 'City' }.text
  end

  def address_to_xml(parent, doc)
    street_element = doc.create_element('Street')
    doc.add_text(street_element, street.to_s)

    city_element = doc.create_element('City')
    doc.add_text(city_element, city.to_s)

    address_element = doc.create_element('Address')
    doc.add_element(address_element, street_element)
    doc.add_element(address_element, city_element)
    doc.add_element(parent, address_element)
  end
end

person = Person.from_json(<<~DATA)
{
  "hobbies": "Singing, Dancing, Running",
  "address": {
    "street": "Oxford Street",
    "city": "London"
  }
}
DATA

person = Person.from_xml(<<~DATA)
<Person hobbies="Singing, Dancing, Running">
  <Address>
    <Street>Oxford Street</Street>
    <City>London</City>
  </Address>
</person>
DATA

# =>
#
# #<Person:0x00007f9bc3086d60
#  @hobbies=["Singing", "Dancing", "Running"],
#  @street="Oxford Street",
#  @city="London">
```

### Pretty printing and XML declaration

If you need formatted output you can pass `:pretty` parameter to `#to_json` and `#to_xml`

```ruby
person.to_json(:pretty)

# =>
#
# {
#   "name": "John Doe",
#   "address": {
#     "city": "London"
#   }
# }
```

You can also add an XML declaration by passing `:declaration` to `#to_xml`

```ruby
person.to_xml(:pretty, :declaration)

# =>
#
# <?xml version="1.0"?>
# <Person>
#   <Address city="London"/>
# </Person>
```

### Supported types

Shale supports these types out of the box:

- `Shale::Type::Boolean`
- `Shale::Type::Date`
- `Shale::Type::Float`
- `Shale::Type::Integer`
- `Shale::Type::String`
- `Shale::Type::Time`

### Writing your own type

To add your own type extend it from `Shale::Type::Value` and implement `.cast` class method.

```ruby
require 'shale/type/value'

class MyIntegerType < Shale::Type::Value
  def self.cast(value)
    value.to_i
  end
end
```

### Adapters

Shale uses adapters for parsing and generating documents.
By default Ruby's standard JSON and YAML parsers are used for handling JSON and YAML documents.

You can change it by providing your own adapter. For JSON and YAML, adapter must implement
`.load` and `.dump` class methods.

```ruby
require 'shale'
require 'multi_json'

Shale.json_adapter = MultiJson
Shale.yaml_adapter = MyYamlAdapter
```

To handle XML documents you have to explicitly set XML adapter.
Shale provides adapters for most popular Ruby XML parsers:

:warning: **Ox doesn't support XML namespaces**

```ruby
require 'shale'

# if you want to use REXML:

require 'shale/adapter/rexml'
Shale.xml_adapter = Shale::Adapter::REXML

# if you want to use Nokogiri:

require 'shale/adapter/nokogiri'
Shale.xml_adapter = Shale::Adapter::Nokogiri

# or if you want to use Ox:

require 'shale/adapter/ox'
Shale.xml_adapter = Shale::Adapter::Ox
```

### Generating JSON Schema

:warning: Only **[Draft 2020-12](https://json-schema.org/draft/2020-12/schema)** JSON Schema is supported

To generate JSON Schema from your Shale data model use:

```ruby
require 'shale/schema'

Shale::Schema.to_json(
  Person,
  id: 'http://foo.bar/schema/person',
  description: 'My description',
  pretty: true
)

# =>
#
# {
#   "$schema": "https://json-schema.org/draft/2020-12/schema",
#   "$id": "http://foo.bar/schema/person",
#   "description": "My description",
#   "$ref": "#/$defs/Person",
#   "$defs": {
#     "Address": {
#       "type": [
#         "object",
#         "null"
#       ],
#       "properties": {
#         "city": {
#           "type": [
#             "string",
#             "null"
#           ]
#         }
#       }
#     },
#     "Person": {
#       "type": "object",
#       "properties": {
#         "name": {
#           "type": [
#             "string",
#             "null"
#           ]
#         },
#         "address": {
#           "$ref": "#/$defs/Address"
#         }
#       }
#     }
#   }
# }
```

You can also use a command line tool to do it:

```
$ shaleb -i data_model.rb -r Person -p
```

If you want to convert your own types to JSON Schema types use:

```ruby
require 'shale'
require 'shale/schema'

class MyEmailType < Shale::Type::Value
  ...
end

class MyEmailJSONType < Shale::Schema::JSONGenerator::Base
  def as_type
    { 'type' => 'string', 'format' => 'email' }
  end
end

Shale::Schema::JSONGenerator.register_json_type(MyEmailType, MyEmailJSONType)
```

### Compiling JSON Schema into Shale model

:warning: Only **[Draft 2020-12](https://json-schema.org/draft/2020-12/schema)** JSON Schema is supported

To generate Shale data model from JSON Schema use:

```ruby
require 'shale/schema'

schema = <<~SCHEMA
{
  "type": "object",
  "properties": {
    "firstName": { "type": "string" },
    "lastName": { "type": "string" },
    "address": {
      "type": "object",
      "properties": {
        "street": { "type": "string" },
        "city": { "type": "string" }
      }
    }
  }
}
SCHEMA

Shale::Schema.from_json([schema], root_name: 'Person')

# =>
#
# {
#   "address" => "
#     require 'shale'
#
#     class Address < Shale::Mapper
#       attribute :street, Shale::Type::String
#       attribute :city, Shale::Type::String
#
#       json do
#         map 'street', to: :street
#         map 'city', to: :city
#       end
#     end
#   ",
#   "person" => "
#     require 'shale'
#
#     require_relative 'address'
#
#     class Person < Shale::Mapper
#       attribute :first_name, Shale::Type::String
#       attribute :last_name, Shale::Type::String
#       attribute :address, Address
#
#       json do
#         map 'firstName', to: :first_name
#         map 'lastName', to: :last_name
#         map 'address', to: :address
#       end
#     end
#   "
# }
```

You can also use a command line tool to do it:

```
$ shaleb -c -i schema.json -r Person
```

### Generating XML Schema

To generate XML Schema from your Shale data model use:

```ruby
require 'shale/schema'

Shale::Schema.to_xml(Person, pretty: true)

# =>
#
# {
#   'schema0.xsd' => '
#     <xs:schema
#       elementFormDefault="qualified"
#       attributeFormDefault="qualified"
#       xmlns:xs="http://www.w3.org/2001/XMLSchema"
#       xmlns:foo="http://foo.com"
#     >
#       <xs:import namespace="http://foo.com" schemaLocation="schema1.xsd"/>
#       <xs:element name="person" type="Person"/>
#       <xs:complexType name="Person">
#         <xs:sequence>
#           <xs:element name="name" type="xs:string" minOccurs="0"/>
#           <xs:element ref="foo:address" minOccurs="0"/>
#         </xs:sequence>
#       </xs:complexType>
#     </xs:schema>',
#
#   'schema1.xsd' => '
#     <xs:schema
#       elementFormDefault="qualified"
#       attributeFormDefault="qualified"
#       targetNamespace="http://foo.com"
#       xmlns:xs="http://www.w3.org/2001/XMLSchema"
#       xmlns:foo="http://foo.com"
#     >
#       <xs:element name="address" type="foo:Address"/>
#       <xs:complexType name="Address">
#         <xs:sequence>
#           <xs:element name="city" type="xs:string" minOccurs="0"/>
#         </xs:sequence>
#       </xs:complexType>
#     </xs:schema>'
# }
```

You can also use a command line tool to do it:

```
$ shaleb -i data_model.rb -r Person -p -f xml
```

If you want to convert your own types to XML Schema types use:

```ruby
require 'shale'
require 'shale/schema'

class MyEmailType < Shale::Type::Value
  ...
end

Shale::Schema::XMLGenerator.register_xml_type(MyEmailType, 'myEmailXMLType')
```

### Compiling XML Schema into Shale model

To generate Shale data model from XML Schema use:

```ruby
require 'shale/schema'

schema = <<~SCHEMA
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xs:element name="Person" type="Person" />

  <xs:complexType name="Person">
    <xs:sequence>
      <xs:element name="FirstName" type="xs:string" />
      <xs:element name="LastName" type="xs:string" />
      <xs:element name="Address" type="Address" />
    </xs:sequence>
  </xs:complexType>

  <xs:complexType name="Address">
    <xs:sequence>
      <xs:element name="Street" type="xs:string" />
      <xs:element name="City" type="xs:string" />
    </xs:sequence>
  </xs:complexType>
</xs:schema>
SCHEMA

Shale::Schema.from_xml([schema])

# =>
#
# {
#   "address" => "
#     require 'shale'
#
#     class Address < Shale::Mapper
#       attribute :street, Shale::Type::String
#       attribute :city, Shale::Type::String
#
#       xml do
#         root 'Address'
#
#         map_element 'Street', to: :street
#         map_element 'City', to: :city
#       end
#     end
#   ",
#   "person" => "
#     require 'shale'
#
#     require_relative 'address'
#
#     class Person < Shale::Mapper
#       attribute :first_name, Shale::Type::String
#       attribute :last_name, Shale::Type::String
#       attribute :address, Address
#
#       xml do
#         root 'Person'
#
#         map_element 'FirstName', to: :first_name
#         map_element 'LastName', to: :last_name
#         map_element 'Address', to: :address
#       end
#     end
#   "
# }
```

You can also use a command line tool to do it:

```
$ shaleb -c -f xml -i schema.xml
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kgiszczak/shale.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
