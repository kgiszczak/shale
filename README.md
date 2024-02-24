# Shale

Shale is a Ruby object mapper and serializer for JSON, YAML, TOML, CSV and XML.
It allows you to parse JSON, YAML, TOML, CSV and XML data and convert it into Ruby data structures,
as well as serialize data structures into JSON, YAML, TOML, CSV or XML.

Documentation with interactive examples is available at [Shale website](https://www.shalerb.org)

## Features

* Convert JSON, YAML, TOML, CSV and XML to Ruby data model
* Convert Ruby data model to JSON, YAML, TOML, CSV and XML
* Generate JSON and XML Schema from Ruby models
* Compile JSON and XML Schema into Ruby models
* Out of the box support for JSON, YAML, Tomlib, toml-rb, CSV, Nokogiri, REXML and Ox parsers
* Support for custom adapters

## Installation

Shale supports Ruby (MRI) 3.0+

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
* [Converting TOML to object](#converting-toml-to-object)
* [Converting object to TOML](#converting-object-to-toml)
* [Converting Hash to object](#converting-hash-to-object)
* [Converting object to Hash](#converting-object-to-hash)
* [Converting XML to object](#converting-xml-to-object)
* [Converting object to XML](#converting-object-to-xml)
* [Converting CSV to object](#converting-csv-to-object)
* [Converting object to CSV](#converting-object-to-csv)
* [Converting collections](#converting-collections)
* [Mapping JSON keys to object attributes](#mapping-json-keys-to-object-attributes)
* [Mapping YAML keys to object attributes](#mapping-yaml-keys-to-object-attributes)
* [Mapping TOML keys to object attributes](#mapping-toml-keys-to-object-attributes)
* [Mapping CSV columns to object attributes](#mapping-csv-columns-to-object-attributes)
* [Mapping Hash keys to object attributes](#mapping-hash-keys-to-object-attributes)
* [Mapping XML elements and attributes to object attributes](#mapping-xml-elements-and-attributes-to-object-attributes)
* [Using XML namespaces](#using-xml-namespaces)
* [Rendering nil values](#rendering-nil-values)
* [Using methods to extract and generate data](#using-methods-to-extract-and-generate-data)
* [Delegating fields to child attributes](#delegating-fields-to-child-attributes)
* [Additional options](#additional-options)
* [Using custom models](#using-custom-models)
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

### Converting TOML to object

To use TOML with Shale you have to set adapter you want to use.
It comes with adapters for [Tomlib](https://github.com/kgiszczak/tomlib) and
[toml-rb](https://github.com/emancu/toml-rb).
For details see [Adapters](#adapters) section.

To set it, first make sure Tomlib gem is installed:

```
$ gem install tomlib
```

then setup adapter:

```ruby
require 'sahle/adapter/tomlib'
Shale.toml_adapter = Shale::Adapter::Tomlib

# Alternatively if you'd like to use toml-rb, use:
require 'shale/adapter/toml_rb'
Shale.toml_adapter = Shale::Adapter::TomlRB
```

Now you can use TOML with Shale:

```ruby
person = Person.from_toml(<<~DATA)
first_name = "John"
last_name = "Doe"
age = 50
married = false
hobbies = ["Singing", "Dancing"]
[address]
city = "London"
street = "Oxford Street"
zip = "E1 6AN"
DATA
```

### Converting object to TOML

```ruby
person.to_toml

# =>
#
# first_name = "John"
# last_name = "Doe"
# age = 50
# married = false
# hobbies = [ "Singing", "Dancing" ]
#
# [address]
# city = "London"
# street = "Oxford Street"
# zip = "E1 6AN"
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

Now you can use XML with Shale:

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

### Converting CSV to object

To use CSV with Shale you have to set adapter.
Shale comes with adapter for [csv](https://github.com/ruby/csv).
For details see [Adapters](#adapters) section.

To set it, first make sure CSV gem is installed:

```
$ gem install csv
```

then setup adapter:

```ruby
require 'shale/adapter/csv'
Shale.csv_adapter = Shale::Adapter::CSV
```

Now you can use CSV with Shale.

CSV represents a flat data structure, so you can't map properties to complex types directly,
but you can use methods to map properties to complex types
(see [Using methods to extract and generate data](#using-methods-to-extract-and-generate-data)
section).

`.from_csv` method allways returns an array of records.

```ruby
people = Person.from_csv(<<~DATA)
John,Doe,50,false
DATA
```

### Converting object to CSV

```ruby
people[0].to_csv # or Person.to_csv(people) if you want to convert a collection

# =>
#
# John,Doe,50,false
```

### Converting collections

Shale allows converting collections for formats that support it (JSON, YAML and CSV).
To convert Ruby array to JSON:

```ruby
person1 = Person.new(name: 'John Doe')
person2 = Person.new(name: 'Joe Sixpack')

Person.to_json([person1, person2], pretty: true)
# or Person.to_yaml([person1, person2])
# or Person.to_csv([person1, person2])

# =>
#
# [
#   { "name": "John Doe" },
#   { "name": "Joe Sixpack" }
# ]
```

To convert JSON array to Ruby:

```ruby
Person.from_json(<<~JSON)
[
  { "name": "John Doe" },
  { "name": "Joe Sixpack" }
]
JSON

# =>
#
# [
#   #<Person:0x00000001033dbce8 @name="John Doe">,
#   #<Person:0x00000001033db4c8 @name="Joe Sixpack">
# ]
```

### Mapping JSON keys to object attributes

By default keys are named the same as attributes. To use custom keys use:

:warning: **Declaring custom mapping removes default mapping for given format!**

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

### Mapping TOML keys to object attributes

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String

  toml do
    map 'firstName', to: :first_name
    map 'lastName', to: :last_name
  end
end
```

### Mapping CSV columns to object attributes

For CSV the order of mapping matters, the first argument in the `map` method is only
used as a label in header row. So, in the example below the first column will be mapped
to `:first_name` attribute and the second column to `:last_name`.

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String

  csv do
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

You can use `cdata: true` option on `map_element` and `map_content` to handle CDATA nodes:

```ruby
class Address < Shale::Mapper
  attribute :content, Shale::Type::String

  xml do
    map_content to: :content, cdata: true
  end
end

class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :address, Address

  xml do
    root 'Person'

    map_element 'FirstName', to: :first_name, cdata: true
    map_element 'Address', to: :address
  end
end

person = Person.from_xml(<<~DATA)
<Person>
  <FirstName><![CDATA[John]]></FirstName>
  <Address><![CDATA[Oxford Street]]></Address>
</person>
DATA
```

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

### Rendering nil values

For JSON, YAML, TOML and XML by default, elements with `nil` value are not rendered.
You can change this behavior by using `render_nil: true` on a mapping.
For CSV the default is to render `nil` elements.

```ruby
class Person < Shale::Mapper
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  json do
    map 'first_name', to: :first_name, render_nil: true
    map 'last_name', to: :last_name, render_nil: false
    map 'age', to: :age, render_nil: true
  end

  xml do
    root 'person'

    map_element 'first_name', to: :first_name, render_nil: true
    map_element 'last_name', to: :last_name, render_nil: false
    map_attribute 'age', to: :age, render_nil: true
  end
end

person = Person.new(first_name: nil, last_name: nil, age: nil)

puts person.to_json(pretty: true)

# =>
#
# {
#   "first_name": null,
#   "age": "null"
# }

puts person.to_xml(pretty: true)

# =>
#
# <person age="">
#   <first_name/>
# </person>
```

If you want to change how nil values are rendered for all mappings you can use `render_nil` method:

```ruby
class Base < Shale::Mapper
  json do
    # change render_nil default for all JSON mappings inheriting from Base class
    render_nil true
  end
end

class Person < Base
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :age, Shale::Type::Integer

  json do
    # override default from Base class
    render_nil false

    map 'first_name', to: :first_name
    map 'last_name', to: :last_name
    map 'age', to: :age, render_nil: true # override default
  end
end
```

:warning: The default affects only the mappings declared after setting the default value e.g.

```ruby
class Person < Base
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String

  json do
    render_nil false
    map 'first_name', to: :first_name # render_nil will be false for this mapping

    render_nil true
    map 'last_name', to: :last_name # render_nil will be true for this mapping
  end
end
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

  def hobbies_from_json(model, value)
    model.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_json(model, doc)
    doc['hobbies'] = model.hobbies.join(', ')
  end

  def address_from_json(model, value)
    model.street = value['street']
    model.city = value['city']
  end

  def address_to_json(model, doc)
    doc['address'] = { 'street' => model.street, 'city' => model.city }
  end

  def hobbies_from_xml(model, value)
    model.hobbies = value.split(',').map(&:strip)
  end

  def hobbies_to_xml(model, element, doc)
    doc.add_attribute(element, 'hobbies', model.hobbies.join(', '))
  end

  def address_from_xml(model, node)
    model.street = node.children.find { |e| e.name == 'Street' }.text
    model.city = node.children.find { |e| e.name == 'City' }.text
  end

  def address_to_xml(model, parent, doc)
    street_element = doc.create_element('Street')
    doc.add_text(street_element, model.street.to_s)

    city_element = doc.create_element('City')
    doc.add_text(city_element, model.city.to_s)

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
</Person>
DATA

# =>
#
# #<Person:0x00007f9bc3086d60
#  @hobbies=["Singing", "Dancing", "Running"],
#  @street="Oxford Street",
#  @city="London">
```

You can also pass a `context` object that will be available in extractor/generator methods:

```ruby
class Person < Shale::Mapper
  attribute :password, Shale::Type::String

  json do
    map 'password', using: { from: :password_from_json, to: :password_to_json }
  end

  def password_from_json(model, value, context)
    if context.admin?
      model.password = value
    else
      model.password = '*****'
    end
  end

  def password_to_json(model, doc, context)
    if context.admin?
      doc['password'] = model.password
    else
      doc['password'] = '*****'
    end
  end
end

Person.new(password: 'secret').to_json(context: current_user)
```

If you want to work on multiple elements at a time you can group them using `group` block:

```ruby
class Person < Shale::Mapper
  attribute :name, Shale::Type::String

  json do
    group from: :name_from_json, to: :name_to_json do
      map 'first_name'
      map 'last_name'
    end
  end

  xml do
    group from: :name_from_xml, to: :name_to_xml do
      map_content
      map_element 'first_name'
      map_attribute 'last_name'
    end
  end

  def name_from_json(model, value)
    model.name = "#{value['first_name']} #{value['last_name']}"
  end

  def name_to_json(model, doc)
    doc['first_name'] = model.name.split(' ')[0]
    doc['last_name'] = model.name.split(' ')[1]
  end

  def name_from_xml(model, value)
    # value => { content: ..., attributes: {}, elements: {} }
  end

  def name_to_xml(model, element, doc)
    # ...
  end
end

Person.from_json(<<~DATA)
{
  "first_name": "John",
  "last_name": "Doe"
}
DATA

# => #<Person:0x00007f9bc3086d60 @name="John Doe">
```

### Delegating fields to child attributes

To delegate fields to child complex types you can use `receiver: :child` declaration:

```ruby
class Address < Shale::Mapper
  attribute :city, Shale::Type::String
  attribute :street, Shale::Type::String
end

class Person < Shale::Mapper
  attribute :name, Shale::Type::String
  attribute :address, Address

  json do
    map 'name', to: :name
    map 'city', to: :city, receiver: :address
    map 'street', to: :street, receiver: :address
  end
end

person = Person.from_json(<<~DATA)
{
  "name": "John Doe",
  "city": "London",
  "street": "Oxford Street"
}
DATA

# =>
#
# #<Person:0x00007f9bc3086d60
#  @name="John Doe",
#  @address=#<Address:0x0000000102cbd218 @city="London", @street="Oxford Street">>
```

### Additional options

You can control which attributes to render and parse by
using `only: []` and `except: []` parameters.

```ruby
# e.g. if you have this model graph:
person = Person.new(
  first_name: 'John'
  last_name: 'Doe',
  address: Address.new(city: 'London', street: 'Oxford Street')
)

# if you want to render only `first_name` and `address.city` do:
person.to_json(only: [:first_name, address: [:city]], pretty: true)

# =>
#
# {
#   "first_name": "John",
#   "address": {
#     "city": "London"
#   }
# }

# and if you don't need an address you can do:
person.to_json(except: [:address], pretty: true)

# =>
#
# {
#   "first_name": "John",
#   "last_name": "Doe"
# }
```

It works the same for parsing:

```ruby
# e.g. if you want to parse only `address.city` do:
Person.from_json(doc, only: [address: [:city]])

# =>
#
# #<Person:0x0000000113d7a488
#  @first_name=nil,
#  @last_name=nil,
#  @address=#<Address:0x0000000113d7a140 @street=nil, @city="London">>

# and if you don't need an `address`:
Person.from_json(doc, except: [:address])

# =>
#
# #<Person:0x0000000113d7a488
#  @first_name="John",
#  @last_name="Doe",
#  @address=nil>
```

If you need formatted output you can pass `pretty: true` parameter to `#to_json` and `#to_xml`

```ruby
person.to_json(pretty: true)

# =>
#
# {
#   "name": "John Doe",
#   "address": {
#     "city": "London"
#   }
# }
```

You can also add an XML declaration by passing `declaration: true` and `encoding: true`
or if you want to spcify version: `declaration: '1.1'` and `encoding: 'ASCII'` to `#to_xml`

```ruby
person.to_xml(pretty: true, declaration: true, encoding: true)

# =>
#
# <?xml version="1.0" encoding="UTF-8"?>
# <Person>
#   <Address city="London"/>
# </Person>
```

For CSV you can pass `headers: true` to indicate that the first row contains column
names and shouldn't be included in the returned collection. It also accepts all the options that
[CSV parser](https://ruby-doc.org/stdlib-3.1.2/libdoc/csv/rdoc/CSV.html#class-CSV-label-Options) accepts.

```ruby
class Person
  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
end

people = Person.from_csv(<<~DATA, headers: true, col_sep: '|')
  first_name|last_name
  John|Doe
  James|Sixpack
DATA

# =>
#
# [
#   #<Person:0x0000000113d7a488 @first_name="John", @last_name="Doe">,
#   #<Person:0x0000000113d7a488 @first_name="James", @last_name="Sixpack">
# ]

Person.to_csv(people, headers: true, col_sep: '|')

# =>
#
# first_name|last_name
# John|Doe
# James|Sixpack
```

Most adapters accept options specific to them. Eg. if you want to be able to work
with NaN values in JSON:

```ruby
class Person
  attribute :age, Shale::Type::Float
end

person = Person.from_jsom('{"age": NaN}', allow_nan: true)

# =>
#
# #<Person:0x0000000113d7a488 @age=Float::NAN>

Person.to_json(person, allow_nan: true)

# =>
#
# {
#   "age": NaN
# }
```

### Using custom models

By default Shale combines mapper and model into one class. If you want to use your own classes
as models you can do it by using `model` directive on the mapper:

```ruby
class Address
  attr_accessor :street, :city
end

class Person
  attr_accessor :first_name, :last_name, :address
end

class AddressMapper < Shale::Mapper
  model Address

  attribute :street, Shale::Type::String
  attribute :city, Shale::Type::String
end

class PersonMapper < Shale::Mapper
  model Person

  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :address, AddressMapper
end

person = PersonMapper.from_json(<<~DATA)
{
  "first_name": "John",
  "last_name": "Doe",
  "address": {
    "street": "Oxford Street",
    "city": "London"
  }
}
DATA

# =>
#
# #<Person:0x0000000113d7a488
#  @first_name="John",
#  @last_name="Doe",
#  @address=#<Address:0x0000000113d7a140 @street="Oxford Street", @city="London">>

PersonMapper.to_json(person, pretty: true)

# =>
#
# {
#   "first_name": "John",
#   "last_name": "Doe",
#   "address": {
#     "street": "Oxford Street",
#     "city": "London"
#   }
# }
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

You can change it by providing your own adapter. For JSON, YAML, TOML and CSV adapter must
implement `.load` and `.dump` class methods.

```ruby
require 'shale'
require 'multi_json'

Shale.json_adapter = MultiJson
Shale.yaml_adapter = MyYamlAdapter
```

To handle TOML documents you have to set TOML adapter. Out of the box `Tomlib` is supported.
Shale also provides adapter for `toml-rb` parser:

```ruby
require 'shale'

# if you want to use Tomlib
require 'tomlib'
Shale.toml_adapter = Tomlib

# if you want to use toml-rb
require 'shale/adapter/toml_rb'
Shale.toml_adapter = Shale::Adapter::TomlRB
```

To handle CSV documents you have to set CSV adapter. Shale provides adapter for `csv` parser:

```ruby
require 'shale'
require 'shale/adapter/csv'
Shale.csv_adapter = Shale::Adapter::CSV
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

To add validation keywords to the schema, you can use a custom model and do this:

```ruby
require 'shale/schema'

class PersonMapper < Shale::Mapper
  model Person

  attribute :first_name, Shale::Type::String
  attribute :last_name, Shale::Type::String
  attribute :address, Shale::Type::String
  attribute :age, Shale::Type::Integer

  json do
    properties max_properties: 5

    map "first_name", to: :first_name, schema: { required: true }
    map "last_name", to: :last_name, schema: { required: true }
    map "address", to: :age, schema: { max_length: 128 }
    map "age", to: :age, schema: { minimum: 1, maximum: 150 }
  end
end

Shale::Schema.to_json(
  PersonMapper,
  pretty: true
)

# =>
#
# {
#   "$schema": "https://json-schema.org/draft/2020-12/schema",
#   "description": "My description",
#   "$ref": "#/$defs/Person",
#   "$defs": {
#     "Person": {
#       "type": "object",
#       "maxProperties": 5,
#       "properties": {
#         "first_name": {
#           "type": "string"
#         },
#         "last_name": {
#           "type": "string"
#         },
#         "age": {
#           "type": [
#             "integer",
#             "null"
#           ],
#          "minimum": 1,
#          "maximum": 150
#        },
#         "address": {
#           "type": [
#             "string",
#             "null"
#           ],
#           "maxLength": 128
#         }
#       },
#       "required": ["first_name", "last_name"]
#     }
#   }
# }
```

Validation keywords are supported for all types, only the global `enum` and `const` types are not supported.

### Compiling JSON Schema into Shale model

:warning: Only **[Draft 2020-12](https://json-schema.org/draft/2020-12/schema)** JSON Schema is supported

To generate Shale data model from JSON Schema use `Shale::Schema.from_json`.
You can pass `root_name: 'Foobar'` to change the name of the root type and
`namespace_mapping: {}` to map schemas to Ruby modules:

```ruby
require 'shale/schema'

schema = <<~SCHEMA
{
  "type": "object",
  "properties": {
    "firstName": { "type": "string" },
    "lastName": { "type": "string" },
    "address": { "$ref": "http://bar.com" }
  },
  "$defs": {
    "Address": {
      "$id": "http://bar.com",
      "type": "object",
      "properties": {
        "street": { "type": "string" },
        "city": { "type": "string" }
      }
    }
  }
}
SCHEMA

Shale::Schema.from_json(
  [schema],
  root_name: 'Person',
  namespace_mapping: {
    nil => 'Api::Foo', # default schema (without ID)
    'http://bar.com' => 'Api::Bar',
  }
)

# =>
#
# {
#   "api/bar/address" => "
#     require 'shale'
#
#     module Api
#       module Bar
#         class Address < Shale::Mapper
#           attribute :street, Shale::Type::String
#           attribute :city, Shale::Type::String
#
#           json do
#             map 'street', to: :street
#             map 'city', to: :city
#           end
#         end
#       end
#     end
#   ",
#   "api/foo/person" => "
#     require 'shale'
#
#     require_relative '../bar/address'
#
#     module Api
#       module Foo
#         class Person < Shale::Mapper
#           attribute :first_name, Shale::Type::String
#           attribute :last_name, Shale::Type::String
#           attribute :address, Api::Bar::Address
#
#           json do
#             map 'firstName', to: :first_name
#             map 'lastName', to: :last_name
#             map 'address', to: :address
#           end
#         end
#       end
#     end
#   "
# }
```

You can also use a command line tool to do it:

```
$ shaleb -c -i schema.json -r Person -m http://bar.com=Api::Bar,=Api::Foo
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

To generate Shale data model from XML Schema use `Shale::Schema.from_xml`.
You can pass `namespace_mapping: {}` to map XML namespaces to Ruby modules:

```ruby
require 'shale/schema'

schema1 = <<~SCHEMA
<xs:schema
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:bar="http://bar.com"
  elementFormDefault="qualified"
>
  <xs:import namespace="http://bar.com" />

  <xs:element name="Person" type="Person" />

  <xs:complexType name="Person">
    <xs:sequence>
      <xs:element name="Name" type="xs:string" />
      <xs:element ref="bar:Address" />
    </xs:sequence>
  </xs:complexType>
</xs:schema>
SCHEMA

schema2 = <<~SCHEMA
<xs:schema
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:bar="http://bar.com"
  targetNamespace="http://bar.com"
  elementFormDefault="qualified"
>
  <xs:element name="Address" type="bar:Address" />

  <xs:complexType name="Address">
    <xs:sequence>
      <xs:element name="Street" type="xs:string" />
      <xs:element name="City" type="xs:string" />
    </xs:sequence>
  </xs:complexType>
</xs:schema>
SCHEMA

Shale::Schema.from_xml(
  [schema1, schema2],
  namespace_mapping: {
    nil => 'Api::Foo', # no namespace
    'http://bar.com' => 'Api::Bar',
  }
)

# =>
#
# {
#   "api/bar/address" => "
#     require 'shale'
#
#     module Api
#       module Bar
#         class Address < Shale::Mapper
#           attribute :street, Shale::Type::String
#           attribute :city, Shale::Type::String
#
#           xml do
#             root 'Address'
#             namespace 'http://bar.com', 'bar'
#
#             map_element 'Street', to: :street
#             map_element 'City', to: :city
#           end
#         end
#       end
#     end
#   ",
#   "api/foo/person" => "
#     require 'shale'
#
#     require_relative '../bar/address'
#
#     module Api
#       module Foo
#         class Person < Shale::Mapper
#           attribute :name, Shale::Type::String
#           attribute :address, Api::Bar::Address
#
#           xml do
#             root 'Person'
#
#             map_element 'Name', to: :name
#             map_element 'Address', to: :address, prefix: 'bar', namespace: 'http://bar.com'
#           end
#         end
#       end
#     end
#   "
# }
```

You can also use a command line tool to do it:

```
$ shaleb -c -f xml -i schema.xml -m http://bar.com=Api::Bar,=Api::Foo
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kgiszczak/shale.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
