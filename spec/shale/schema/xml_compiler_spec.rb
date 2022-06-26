# frozen_string_literal: true

require 'shale/adapter/ox'
require 'shale/adapter/rexml'
require 'shale/schema/compiler/boolean'
require 'shale/schema/compiler/date'
require 'shale/schema/compiler/float'
require 'shale/schema/compiler/integer'
require 'shale/schema/compiler/string'
require 'shale/schema/compiler/time'
require 'shale/schema/compiler/value'
require 'shale/schema/xml_compiler'

schema_top_level_complex_types = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="person_sequence" type="PersonSequence"/>
    <xs:element name="person_all" type="PersonAll"/>
    <xs:element name="person_choice" type="PersonChoice"/>
    <xs:element name="shipping" type="Shipping"/>
    <xs:element name="billing" type="Billing"/>

    <xs:complexType name="PersonAll">
      <xs:all>
        <xs:element name="FirstName" type="xs:string" default="John" />
        <xs:element name="LastName" type="xs:string"/>
        <xs:element name="Married" type="xs:boolean" default="false" />
      </xs:all>
      <xs:attribute name="age" type="xs:string"/>
    </xs:complexType>

    <xs:complexType name="PersonSequence">
      <xs:sequence>
        <xs:element name="first_name" type="xs:string"/>
        <xs:element name="last_name" type="xs:string"/>
      </xs:sequence>
      <xs:attribute name="Age" type="xs:string"/>
    </xs:complexType>

    <xs:complexType name="PersonChoice">
      <xs:choice>
        <xs:element name="first_name" type="xs:string"/>
        <xs:element name="last_name" type="xs:string"/>
      </xs:choice>
      <xs:attribute name="age" type="xs:string"/>
    </xs:complexType>

    <xs:complexType name="Address">
      <xs:sequence>
        <xs:element name="city" type="xs:string"/>
        <xs:element name="street" type="xs:string"/>
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="Shipping">
      <xs:sequence>
        <xs:element name="shipping_address" type="Address"/>
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="Billing">
      <xs:sequence>
        <xs:element name="billing_address" type="Address"/>
      </xs:sequence>
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_inline_complex_types = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="BillingInfo">
      <xs:complexType>
        <xs:sequence>
          <xs:element name="Address">
            <xs:complexType>
              <xs:sequence>
                <xs:element name="Street">
                  <xs:complexType>
                    <xs:sequence>
                      <xs:element name="Name" type="xs:string" />
                    </xs:sequence>
                    <xs:attribute name="Number" type="xs:string"/>
                  </xs:complexType>
                </xs:element>
              </xs:sequence>
              <xs:attribute name="Flat" type="xs:string"/>
            </xs:complexType>
          </xs:element>
        </xs:sequence>
      </xs:complexType>
    </xs:element>

    <xs:element name="ShippingInfo">
      <xs:complexType>
        <xs:sequence>
          <xs:element name="Address">
            <xs:complexType>
              <xs:sequence>
                <xs:element name="City" type="xs:string" />
              </xs:sequence>
            </xs:complexType>
          </xs:element>
        </xs:sequence>
      </xs:complexType>
    </xs:element>
  </xs:schema>
SCHEMA

schema_simple_types = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="complex-type" type="complex-type" />
    <xs:element name="complex-type-inline" type="complex-type-inline" />

    <xs:simpleType name="simple-type-restriction">
      <xs:restriction base="xs:integer">
      </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="simple-type-restriction-ref">
      <xs:restriction base="simple-type-restriction">
      </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="simple-type-restriction-ref-ref">
      <xs:restriction base="simple-type-restriction-ref">
      </xs:restriction>
    </xs:simpleType>

    <xs:simpleType name="simple-type-list">
      <xs:list itemType="xs:integer" />
    </xs:simpleType>

    <xs:simpleType name="simple-type-union">
      <xs:union memberTypes="xs:integer xs:string" />
    </xs:simpleType>

    <xs:simpleType name="simple-type-restriction-inline">
      <xs:restriction>
        <xs:simpleType>
          <xs:restriction base="xs:integer">
          </xs:restriction>
        </xs:simpleType>
      </xs:restriction>
    </xs:simpleType>

    <xs:complexType name="complex-type">
      <xs:sequence>
        <xs:element name="el-simple-type-restriction" type="simple-type-restriction" />
        <xs:element name="el-simple-type-restriction-ref" type="simple-type-restriction-ref" />
        <xs:element name="el-simple-type-restriction-ref-ref" type="simple-type-restriction-ref-ref" />
        <xs:element name="el-simple-type-restriction-inline" type="simple-type-restriction-inline" />
        <xs:element name="el-simple-type-restriction-list" type="simple-type-list" />
        <xs:element name="el-simple-type-restriction-union" type="simple-type-union" />
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="complex-type-inline">
      <xs:sequence>
        <xs:element name="el1">
          <xs:simpleType>
            <xs:restriction base="xs:integer">
            </xs:restriction>
          </xs:simpleType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_groups = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="element-test1" type="element-test1" />
    <xs:element name="element-test2" type="element-test2" />
    <xs:element name="attribute-test1" type="attribute-test1" />

    <xs:group name="element-group1">
      <xs:sequence>
        <xs:element name="element-group1-el1" type="xs:string" />
        <xs:group ref="element-group2" />
        <xs:element name="element-group1-el2" type="xs:string" />
      </xs:sequence>
    </xs:group>

    <xs:group name="element-group2">
      <xs:sequence>
        <xs:element name="element-group2-el1" type="xs:string" />
        <xs:element name="element-group2-el2" type="xs:string" />
        <xs:element name="element-group2-el3-inline">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="complex-inline-el1" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:group>

    <xs:complexType name="element-test1">
      <xs:sequence>
        <xs:group ref="element-group1"/>
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="element-test2">
      <xs:group ref="element-group1" />
    </xs:complexType>

    <xs:attributeGroup name="attribute-group1">
      <xs:attribute name="attribute-group1-el1" type="xs:string" />
      <xs:attributeGroup ref="attribute-group2" />
      <xs:attribute name="attribute-group1-el2" type="xs:string" />
    </xs:attributeGroup>

    <xs:attributeGroup name="attribute-group2">
      <xs:attribute name="attribute-group2-el1" type="xs:string" />
      <xs:attribute name="attribute-group2-el2" type="xs:string" />
    </xs:attributeGroup>

    <xs:complexType name="attribute-test1">
      <xs:attributeGroup ref="attribute-group1" />
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_refs = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="person" type="Person" />
    <xs:element name="person-att" type="PersonAtt" />

    <xs:element name="el1" type="xs:string" />
    <xs:element name="el2" type="Address" />
    <xs:element name="el3">
      <xs:complexType>
        <xs:sequence>
          <xs:element name="age" type="xs:string" />
          <xs:element name="sex" type="xs:string" />
        </xs:sequence>
      </xs:complexType>
    </xs:element>

    <xs:complexType name="Address">
      <xs:sequence>
        <xs:element name="city" type="xs:string" />
        <xs:element name="street" type="xs:string" />
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="Person">
      <xs:sequence>
        <xs:element ref="el1" />
        <xs:element ref="el2" />
        <xs:element ref="el3" />
      </xs:sequence>
    </xs:complexType>


    <xs:attribute name="att1" type="xs:string" />
    <xs:attribute name="att2" type="customInt" />
    <xs:attribute name="att3">
      <xs:simpleType>
        <xs:restriction base="xs:integer">
        </xs:restriction>
      </xs:simpleType>
    </xs:attribute>

    <xs:simpleType name="customInt">
      <xs:restriction base="xs:integer">
      </xs:restriction>
    </xs:simpleType>

    <xs:complexType name="PersonAtt">
      <xs:attribute ref="att1" />
      <xs:attribute ref="att2" />
      <xs:attribute ref="att3" />
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_simple_content = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="complex1" type="complex1" />
    <xs:element name="complex2" type="complex2" />

    <xs:simpleType name="customInt">
      <xs:restriction base="xs:integer">
      </xs:restriction>
    </xs:simpleType>

    <xs:complexType name="complex1">
      <xs:simpleContent>
        <xs:extension base="customInt">
        </xs:extension>
      </xs:simpleContent>
    </xs:complexType>

    <xs:complexType name="complex2" mixed="true">
      <xs:sequence>
        <xs:element name="el1" type="xs:integer" />
      </xs:sequence>
    </xs:complexType>

    <xs:element name="shoesize">
      <xs:complexType>
        <xs:simpleContent>
          <xs:extension base="xs:integer">
            <xs:attribute name="country" type="xs:float" />
          </xs:extension>
        </xs:simpleContent>
      </xs:complexType>
    </xs:element>
  </xs:schema>
SCHEMA

schema_complex_content = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="MixedContent" type="MixedContent" />
    <xs:element name="ChildExtension" type="ChildExtension" />
    <xs:element name="ChildRestriction" type="ChildRestriction" />
    <xs:element name="ChildChildExtension" type="ChildChildExtension" />
    <xs:element name="Address" type="Address" />
    <xs:element name="RestrictedAddress" type="RestrictedAddress" />

    <xs:complexType name="BaseType">
      <xs:sequence>
        <xs:element name="BaseElement1" type="xs:string" />
        <xs:element name="BaseElement2" type="xs:integer" />
      </xs:sequence>
      <xs:attribute name="BaseAttribute1" type="xs:date" />
      <xs:attribute name="BaseAttribute2" type="xs:dateTime" />
    </xs:complexType>

    <xs:complexType name="MixedContent">
      <xs:complexContent mixed="true">
        <xs:extension base="BaseType">
        </xs:extension>
      </xs:complexContent>
    </xs:complexType>

    <xs:complexType name="ChildExtension">
      <xs:complexContent>
        <xs:extension base="BaseType">
          <xs:sequence>
            <xs:element name="ChildElementA" type="xs:string" />
          </xs:sequence>
        </xs:extension>
      </xs:complexContent>
    </xs:complexType>

    <xs:complexType name="ChildRestriction">
      <xs:complexContent>
        <xs:restriction base="BaseType">
          <xs:sequence>
            <xs:element name="ChildElementB" type="xs:string" />
          </xs:sequence>
        </xs:restriction>
      </xs:complexContent>
    </xs:complexType>

    <xs:complexType name="ChildChildExtension">
      <xs:complexContent>
        <xs:extension base="ChildExtension">
          <xs:sequence>
            <xs:element name="ChildElementC" type="xs:string" />
          </xs:sequence>
        </xs:extension>
      </xs:complexContent>
    </xs:complexType>

    <xs:complexType name="Address" mixed="true">
      <xs:sequence>
        <xs:element name="Street" type="xs:string" />
        <xs:element name="City" type="xs:string" />
        <xs:element name="Country" type="xs:string" />
      </xs:sequence>
      <xs:attribute name="zip" type="xs:string" />
    </xs:complexType>

    <xs:complexType name="RestrictedAddress">
      <xs:complexContent>
        <xs:restriction base="Address">
          <xs:sequence>
            <xs:element name="Street" type="xs:string" />
            <xs:element name="City" type="xs:string" />
          </xs:sequence>
        </xs:restriction>
      </xs:complexContent>
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_duplicates = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="Shipping" type="Shipping" />
    <xs:element name="Billing" type="Billing" />

    <xs:complexType name="Shipping">
      <xs:sequence>
        <xs:element name="Address">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="shipping" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="Billing">
      <xs:sequence>
        <xs:element name="Address">
          <xs:complexType>
            <xs:sequence>
              <xs:element name="billing" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:element>
      </xs:sequence>
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_circular_references = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="Type1" type="Type1" />

    <xs:complexType name="Type1">
      <xs:sequence>
        <xs:element name="Type2" type="Type2" />
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="Type2">
      <xs:sequence>
        <xs:element name="Type1" type="Type1" />
      </xs:sequence>
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_circular_references = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="Type1" type="Type1" />

    <xs:complexType name="Type1">
      <xs:sequence>
        <xs:element name="Type2" type="Type2" />
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="Type2">
      <xs:sequence>
        <xs:element name="Type1" type="Type1" />
      </xs:sequence>
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_collections = <<~SCHEMA
  <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
    <xs:element name="complex1" type="complex1" />
    <xs:element name="complex2" type="complex2" />
    <xs:element name="top-el1" type="xs:string" />

    <xs:group name="group1">
      <xs:sequence>
        <xs:element name="grup1-el1" type="xs:string" maxOccurs="10" />
      </xs:sequence>
    </xs:group>

    <xs:group name="group2">
      <xs:sequence>
        <xs:element name="grup2-el1" type="xs:string" />
      </xs:sequence>
    </xs:group>

    <xs:complexType name="complex1">
      <xs:sequence>
        <xs:element name="el1" type="xs:string" maxOccurs="10" />
        <xs:group ref="group1" />
        <xs:group ref="group2" maxOccurs="10" />
        <xs:element ref="top-el1" maxOccurs="10" />
      </xs:sequence>
    </xs:complexType>

    <xs:complexType name="complex2">
      <xs:sequence maxOccurs="10">
        <xs:element name="el1" type="xs:string" />
        <xs:group ref="group2" />
        <xs:element ref="top-el1" />
      </xs:sequence>
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_namespaces1 = <<~SCHEMA
  <xs:schema
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:foo="http://foo.com"
    xmlns:bar="http://bar.com"
    targetNamespace="http://bar.com"
    elementFormDefault="qualified"
  >
    <xs:import namespace="http://foo.com" schemaLocation="test11-2.xml" />

    <xs:element name="Person" type="bar:Person" />
    <xs:element name="foobar" type="xs:string" />
    <xs:attribute name="pet" type="xs:string" />

    <xs:complexType name="Person">
      <xs:sequence>
        <xs:element name="FirstName" type="xs:string" />
        <xs:element name="LastName" type="xs:string" />
        <xs:element ref="bar:foobar" />
        <xs:element ref="foo:Address" />
      </xs:sequence>
      <xs:attribute name="age" type="xs:string" />
      <xs:attribute ref="foo:lang" />
      <xs:attribute ref="bar:pet" />
    </xs:complexType>
  </xs:schema>
SCHEMA

schema_namespaces2 = <<~SCHEMA
  <xs:schema
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:foo="http://foo.com"
    targetNamespace="http://foo.com"
    elementFormDefault="qualified"
    attributeFormDefault="qualified"
  >
    <xs:element name="Address" type="foo:Address" />
    <xs:attribute name="lang" type="xs:string" />

    <xs:complexType name="Address">
      <xs:sequence>
        <xs:element name="City" type="xs:string" />
        <xs:element name="Street" type="xs:string" />
      </xs:sequence>
      <xs:attribute name="Number" type="xs:string" />
    </xs:complexType>
  </xs:schema>
SCHEMA

RSpec.describe Shale::Schema::XMLCompiler do
  before(:each) do
    Shale.xml_adapter = Shale::Adapter::REXML
  end

  describe '#as_models' do
    context 'when no adapter is set' do
      it 'raises error' do
        Shale.xml_adapter = nil

        expect do
          described_class.new.as_models(['<asd>'])
        end.to raise_error(Shale::AdapterError, /XML Adapter is not set/)
      end
    end

    context 'when Ox adapter is set' do
      it 'raises error' do
        Shale.xml_adapter = Shale::Adapter::Ox

        expect do
          described_class.new.as_models(['<asd>'])
        end.to raise_error(Shale::AdapterError, /Ox doesn't support XML namespaces/)
      end
    end

    context 'with incorrect schema' do
      it 'raises error' do
        expect do
          described_class.new.as_models(['<asd>'])
        end.to raise_error(Shale::SchemaError, /XML Schema document is invalid/)
      end
    end

    context 'with top level complex types' do
      it 'generates models' do
        models = described_class.new.as_models([schema_top_level_complex_types])

        expect(models.length).to eq(6)

        expect(models[0].id).to eq('Billing')
        expect(models[0].name).to eq('Billing')
        expect(models[0].root).to eq('billing')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('billing_address')
        expect(models[0].properties[0].type).to eq(models[1])
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)

        expect(models[1].id).to eq('Address')
        expect(models[1].name).to eq('Address')
        expect(models[1].root).to eq('Address')
        expect(models[1].properties.length).to eq(2)
        expect(models[1].properties[0].mapping_name).to eq('city')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('street')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[1].collection?).to eq(false)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq(nil)
        expect(models[1].properties[1].namespace).to eq(nil)

        expect(models[2].id).to eq('Shipping')
        expect(models[2].name).to eq('Shipping')
        expect(models[2].root).to eq('shipping')
        expect(models[2].properties.length).to eq(1)
        expect(models[2].properties[0].mapping_name).to eq('shipping_address')
        expect(models[2].properties[0].type).to eq(models[1])
        expect(models[2].properties[0].collection?).to eq(false)
        expect(models[2].properties[0].default).to eq(nil)
        expect(models[2].properties[0].prefix).to eq(nil)
        expect(models[2].properties[0].namespace).to eq(nil)

        expect(models[3].id).to eq('PersonChoice')
        expect(models[3].name).to eq('PersonChoice')
        expect(models[3].root).to eq('person_choice')
        expect(models[3].properties.length).to eq(3)
        expect(models[3].properties[0].mapping_name).to eq('age')
        expect(models[3].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[0].collection?).to eq(false)
        expect(models[3].properties[0].default).to eq(nil)
        expect(models[3].properties[0].prefix).to eq(nil)
        expect(models[3].properties[0].namespace).to eq(nil)
        expect(models[3].properties[1].mapping_name).to eq('first_name')
        expect(models[3].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[1].collection?).to eq(false)
        expect(models[3].properties[1].default).to eq(nil)
        expect(models[3].properties[1].prefix).to eq(nil)
        expect(models[3].properties[1].namespace).to eq(nil)
        expect(models[3].properties[2].mapping_name).to eq('last_name')
        expect(models[3].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[2].collection?).to eq(false)
        expect(models[3].properties[2].default).to eq(nil)
        expect(models[3].properties[2].prefix).to eq(nil)
        expect(models[3].properties[2].namespace).to eq(nil)

        expect(models[4].id).to eq('PersonAll')
        expect(models[4].name).to eq('PersonAll')
        expect(models[4].root).to eq('person_all')
        expect(models[4].properties.length).to eq(4)
        expect(models[4].properties[0].mapping_name).to eq('age')
        expect(models[4].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[4].properties[0].collection?).to eq(false)
        expect(models[4].properties[0].default).to eq(nil)
        expect(models[4].properties[0].prefix).to eq(nil)
        expect(models[4].properties[0].namespace).to eq(nil)
        expect(models[4].properties[1].mapping_name).to eq('FirstName')
        expect(models[4].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[4].properties[1].collection?).to eq(false)
        expect(models[4].properties[1].default).to eq('"John"')
        expect(models[4].properties[1].prefix).to eq(nil)
        expect(models[4].properties[1].namespace).to eq(nil)
        expect(models[4].properties[2].mapping_name).to eq('LastName')
        expect(models[4].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[4].properties[2].collection?).to eq(false)
        expect(models[4].properties[2].default).to eq(nil)
        expect(models[4].properties[2].prefix).to eq(nil)
        expect(models[4].properties[2].namespace).to eq(nil)
        expect(models[4].properties[3].mapping_name).to eq('Married')
        expect(models[4].properties[3].type).to be_a(Shale::Schema::Compiler::Boolean)
        expect(models[4].properties[3].collection?).to eq(false)
        expect(models[4].properties[3].default).to eq('"false"')
        expect(models[4].properties[3].prefix).to eq(nil)
        expect(models[4].properties[3].namespace).to eq(nil)

        expect(models[5].id).to eq('PersonSequence')
        expect(models[5].name).to eq('PersonSequence')
        expect(models[5].root).to eq('person_sequence')
        expect(models[5].properties.length).to eq(3)
        expect(models[5].properties[0].mapping_name).to eq('Age')
        expect(models[5].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[5].properties[0].collection?).to eq(false)
        expect(models[5].properties[0].default).to eq(nil)
        expect(models[5].properties[0].prefix).to eq(nil)
        expect(models[5].properties[0].namespace).to eq(nil)
        expect(models[5].properties[1].mapping_name).to eq('first_name')
        expect(models[5].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[5].properties[1].collection?).to eq(false)
        expect(models[5].properties[1].default).to eq(nil)
        expect(models[5].properties[1].prefix).to eq(nil)
        expect(models[5].properties[1].namespace).to eq(nil)
        expect(models[5].properties[2].mapping_name).to eq('last_name')
        expect(models[5].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[5].properties[2].collection?).to eq(false)
        expect(models[5].properties[2].default).to eq(nil)
        expect(models[5].properties[2].prefix).to eq(nil)
        expect(models[5].properties[2].namespace).to eq(nil)
      end
    end

    context 'with inline complex types' do
      it 'generates models' do
        models = described_class.new.as_models([schema_inline_complex_types])

        expect(models.length).to eq(5)

        expect(models[0].id).to eq('ShippingInfo/Address')
        expect(models[0].name).to eq('Address2')
        expect(models[0].root).to eq('Address')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('City')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)

        expect(models[1].id).to eq('ShippingInfo')
        expect(models[1].name).to eq('ShippingInfo')
        expect(models[1].root).to eq('ShippingInfo')
        expect(models[1].properties.length).to eq(1)
        expect(models[1].properties[0].mapping_name).to eq('Address')
        expect(models[1].properties[0].type).to eq(models[0])
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)

        expect(models[2].id).to eq('BillingInfo/Address/Street')
        expect(models[2].name).to eq('Street')
        expect(models[2].root).to eq('Street')
        expect(models[2].properties.length).to eq(2)
        expect(models[2].properties[0].mapping_name).to eq('Number')
        expect(models[2].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[0].collection?).to eq(false)
        expect(models[2].properties[0].default).to eq(nil)
        expect(models[2].properties[0].prefix).to eq(nil)
        expect(models[2].properties[0].namespace).to eq(nil)
        expect(models[2].properties[1].mapping_name).to eq('Name')
        expect(models[2].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[1].collection?).to eq(false)
        expect(models[2].properties[1].default).to eq(nil)
        expect(models[2].properties[1].prefix).to eq(nil)
        expect(models[2].properties[1].namespace).to eq(nil)

        expect(models[3].id).to eq('BillingInfo/Address')
        expect(models[3].name).to eq('Address1')
        expect(models[3].root).to eq('Address')
        expect(models[3].properties.length).to eq(2)
        expect(models[3].properties[0].mapping_name).to eq('Flat')
        expect(models[3].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[0].collection?).to eq(false)
        expect(models[3].properties[0].default).to eq(nil)
        expect(models[3].properties[0].prefix).to eq(nil)
        expect(models[3].properties[0].namespace).to eq(nil)
        expect(models[3].properties[1].mapping_name).to eq('Street')
        expect(models[3].properties[1].type).to eq(models[2])
        expect(models[3].properties[1].collection?).to eq(false)
        expect(models[3].properties[1].default).to eq(nil)
        expect(models[3].properties[1].prefix).to eq(nil)
        expect(models[3].properties[1].namespace).to eq(nil)

        expect(models[4].id).to eq('BillingInfo')
        expect(models[4].name).to eq('BillingInfo')
        expect(models[4].root).to eq('BillingInfo')
        expect(models[4].properties.length).to eq(1)
        expect(models[4].properties[0].mapping_name).to eq('Address')
        expect(models[4].properties[0].type).to eq(models[3])
        expect(models[4].properties[0].collection?).to eq(false)
        expect(models[4].properties[0].default).to eq(nil)
        expect(models[4].properties[0].prefix).to eq(nil)
        expect(models[4].properties[0].namespace).to eq(nil)
      end
    end

    context 'with simple types' do
      it 'generates models' do
        models = described_class.new.as_models([schema_simple_types])

        expect(models.length).to eq(2)

        expect(models[0].id).to eq('complex-type-inline')
        expect(models[0].name).to eq('ComplexTypeInline')
        expect(models[0].root).to eq('complex-type-inline')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('el1')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)

        expect(models[1].id).to eq('complex-type')
        expect(models[1].name).to eq('ComplexType')
        expect(models[1].root).to eq('complex-type')
        expect(models[1].properties.length).to eq(6)
        expect(models[1].properties[0].mapping_name).to eq('el-simple-type-restriction')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('el-simple-type-restriction-ref')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[1].properties[1].collection?).to eq(false)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq(nil)
        expect(models[1].properties[1].namespace).to eq(nil)
        expect(models[1].properties[2].mapping_name).to eq('el-simple-type-restriction-ref-ref')
        expect(models[1].properties[2].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[1].properties[2].collection?).to eq(false)
        expect(models[1].properties[2].default).to eq(nil)
        expect(models[1].properties[2].prefix).to eq(nil)
        expect(models[1].properties[2].namespace).to eq(nil)
        expect(models[1].properties[3].mapping_name).to eq('el-simple-type-restriction-inline')
        expect(models[1].properties[3].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[1].properties[3].collection?).to eq(false)
        expect(models[1].properties[3].default).to eq(nil)
        expect(models[1].properties[3].prefix).to eq(nil)
        expect(models[1].properties[3].namespace).to eq(nil)
        expect(models[1].properties[4].mapping_name).to eq('el-simple-type-restriction-list')
        expect(models[1].properties[4].type).to be_a(Shale::Schema::Compiler::Value)
        expect(models[1].properties[4].collection?).to eq(false)
        expect(models[1].properties[4].default).to eq(nil)
        expect(models[1].properties[4].prefix).to eq(nil)
        expect(models[1].properties[4].namespace).to eq(nil)
        expect(models[1].properties[5].mapping_name).to eq('el-simple-type-restriction-union')
        expect(models[1].properties[5].type).to be_a(Shale::Schema::Compiler::Value)
        expect(models[1].properties[5].collection?).to eq(false)
        expect(models[1].properties[5].default).to eq(nil)
        expect(models[1].properties[5].prefix).to eq(nil)
        expect(models[1].properties[5].namespace).to eq(nil)
      end
    end

    context 'with groups' do
      it 'generates models' do
        models = described_class.new.as_models([schema_groups])

        expect(models.length).to eq(4)

        expect(models[0].id).to eq('attribute-test1')
        expect(models[0].name).to eq('AttributeTest1')
        expect(models[0].root).to eq('attribute-test1')
        expect(models[0].properties.length).to eq(4)
        expect(models[0].properties[0].mapping_name).to eq('attribute-group1-el1')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)
        expect(models[0].properties[1].mapping_name).to eq('attribute-group2-el1')
        expect(models[0].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[1].collection?).to eq(false)
        expect(models[0].properties[1].default).to eq(nil)
        expect(models[0].properties[1].prefix).to eq(nil)
        expect(models[0].properties[1].namespace).to eq(nil)
        expect(models[0].properties[2].mapping_name).to eq('attribute-group2-el2')
        expect(models[0].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[2].collection?).to eq(false)
        expect(models[0].properties[2].default).to eq(nil)
        expect(models[0].properties[2].prefix).to eq(nil)
        expect(models[0].properties[2].namespace).to eq(nil)
        expect(models[0].properties[3].mapping_name).to eq('attribute-group1-el2')
        expect(models[0].properties[3].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[3].collection?).to eq(false)
        expect(models[0].properties[3].default).to eq(nil)
        expect(models[0].properties[3].prefix).to eq(nil)
        expect(models[0].properties[3].namespace).to eq(nil)

        expect(models[1].id).to eq('element-test2')
        expect(models[1].name).to eq('ElementTest2')
        expect(models[1].root).to eq('element-test2')
        expect(models[1].properties.length).to eq(5)
        expect(models[1].properties[0].mapping_name).to eq('element-group1-el1')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('element-group2-el1')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[1].collection?).to eq(false)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq(nil)
        expect(models[1].properties[1].namespace).to eq(nil)
        expect(models[1].properties[2].mapping_name).to eq('element-group2-el2')
        expect(models[1].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[2].collection?).to eq(false)
        expect(models[1].properties[2].default).to eq(nil)
        expect(models[1].properties[2].prefix).to eq(nil)
        expect(models[1].properties[2].namespace).to eq(nil)
        expect(models[1].properties[3].mapping_name).to eq('element-group2-el3-inline')
        expect(models[1].properties[3].type).to eq(models[2])
        expect(models[1].properties[3].collection?).to eq(false)
        expect(models[1].properties[3].default).to eq(nil)
        expect(models[1].properties[3].prefix).to eq(nil)
        expect(models[1].properties[3].namespace).to eq(nil)
        expect(models[1].properties[4].mapping_name).to eq('element-group1-el2')
        expect(models[1].properties[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[4].collection?).to eq(false)
        expect(models[1].properties[4].default).to eq(nil)
        expect(models[1].properties[4].prefix).to eq(nil)
        expect(models[1].properties[4].namespace).to eq(nil)

        expect(models[2].id).to eq('element-group2/element-group2-el3-inline')
        expect(models[2].name).to eq('ElementGroup2El3Inline')
        expect(models[2].root).to eq('element-group2-el3-inline')
        expect(models[2].properties.length).to eq(1)
        expect(models[2].properties[0].mapping_name).to eq('complex-inline-el1')
        expect(models[2].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[0].collection?).to eq(false)
        expect(models[2].properties[0].default).to eq(nil)
        expect(models[2].properties[0].prefix).to eq(nil)
        expect(models[2].properties[0].namespace).to eq(nil)

        expect(models[3].id).to eq('element-test1')
        expect(models[3].name).to eq('ElementTest1')
        expect(models[3].root).to eq('element-test1')
        expect(models[3].properties.length).to eq(5)
        expect(models[3].properties[0].mapping_name).to eq('element-group1-el1')
        expect(models[3].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[0].collection?).to eq(false)
        expect(models[3].properties[0].default).to eq(nil)
        expect(models[3].properties[0].prefix).to eq(nil)
        expect(models[3].properties[0].namespace).to eq(nil)
        expect(models[3].properties[1].mapping_name).to eq('element-group2-el1')
        expect(models[3].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[1].collection?).to eq(false)
        expect(models[3].properties[1].default).to eq(nil)
        expect(models[3].properties[1].prefix).to eq(nil)
        expect(models[3].properties[1].namespace).to eq(nil)
        expect(models[3].properties[2].mapping_name).to eq('element-group2-el2')
        expect(models[3].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[2].collection?).to eq(false)
        expect(models[3].properties[2].default).to eq(nil)
        expect(models[3].properties[2].prefix).to eq(nil)
        expect(models[3].properties[2].namespace).to eq(nil)
        expect(models[3].properties[3].mapping_name).to eq('element-group2-el3-inline')
        expect(models[3].properties[3].type).to eq(models[2])
        expect(models[3].properties[3].collection?).to eq(false)
        expect(models[3].properties[3].default).to eq(nil)
        expect(models[3].properties[3].prefix).to eq(nil)
        expect(models[3].properties[3].namespace).to eq(nil)
        expect(models[3].properties[4].mapping_name).to eq('element-group1-el2')
        expect(models[3].properties[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[4].collection?).to eq(false)
        expect(models[3].properties[4].default).to eq(nil)
        expect(models[3].properties[4].prefix).to eq(nil)
        expect(models[3].properties[4].namespace).to eq(nil)
      end
    end

    context 'with refs' do
      it 'generates models' do
        models = described_class.new.as_models([schema_refs])

        expect(models.length).to eq(4)

        expect(models[0].id).to eq('PersonAtt')
        expect(models[0].name).to eq('PersonAtt')
        expect(models[0].root).to eq('person-att')
        expect(models[0].properties.length).to eq(3)
        expect(models[0].properties[0].mapping_name).to eq('att1')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)
        expect(models[0].properties[1].mapping_name).to eq('att2')
        expect(models[0].properties[1].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[0].properties[1].collection?).to eq(false)
        expect(models[0].properties[1].default).to eq(nil)
        expect(models[0].properties[1].prefix).to eq(nil)
        expect(models[0].properties[1].namespace).to eq(nil)
        expect(models[0].properties[2].mapping_name).to eq('att3')
        expect(models[0].properties[2].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[0].properties[2].collection?).to eq(false)
        expect(models[0].properties[2].default).to eq(nil)
        expect(models[0].properties[2].prefix).to eq(nil)
        expect(models[0].properties[2].namespace).to eq(nil)

        expect(models[1].id).to eq('el3')
        expect(models[1].name).to eq('El3')
        expect(models[1].root).to eq('el3')
        expect(models[1].properties.length).to eq(2)
        expect(models[1].properties[0].mapping_name).to eq('age')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('sex')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[1].collection?).to eq(false)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq(nil)
        expect(models[1].properties[1].namespace).to eq(nil)

        expect(models[2].id).to eq('Address')
        expect(models[2].name).to eq('Address')
        expect(models[2].root).to eq('el2')
        expect(models[2].properties.length).to eq(2)
        expect(models[2].properties[0].mapping_name).to eq('city')
        expect(models[2].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[0].collection?).to eq(false)
        expect(models[2].properties[0].default).to eq(nil)
        expect(models[2].properties[0].prefix).to eq(nil)
        expect(models[2].properties[0].namespace).to eq(nil)
        expect(models[2].properties[1].mapping_name).to eq('street')
        expect(models[2].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[1].collection?).to eq(false)
        expect(models[2].properties[1].default).to eq(nil)
        expect(models[2].properties[1].prefix).to eq(nil)
        expect(models[2].properties[1].namespace).to eq(nil)

        expect(models[3].id).to eq('Person')
        expect(models[3].name).to eq('Person')
        expect(models[3].root).to eq('person')
        expect(models[3].properties.length).to eq(3)
        expect(models[3].properties[0].mapping_name).to eq('el1')
        expect(models[3].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[0].collection?).to eq(false)
        expect(models[3].properties[0].default).to eq(nil)
        expect(models[3].properties[0].prefix).to eq(nil)
        expect(models[3].properties[0].namespace).to eq(nil)
        expect(models[3].properties[1].mapping_name).to eq('el2')
        expect(models[3].properties[1].type).to eq(models[2])
        expect(models[3].properties[1].collection?).to eq(false)
        expect(models[3].properties[1].default).to eq(nil)
        expect(models[3].properties[1].prefix).to eq(nil)
        expect(models[3].properties[1].namespace).to eq(nil)
        expect(models[3].properties[2].mapping_name).to eq('el3')
        expect(models[3].properties[2].type).to eq(models[1])
        expect(models[3].properties[2].collection?).to eq(false)
        expect(models[3].properties[2].default).to eq(nil)
        expect(models[3].properties[2].prefix).to eq(nil)
        expect(models[3].properties[2].namespace).to eq(nil)
      end
    end

    context 'with simple content' do
      it 'generates models' do
        models = described_class.new.as_models([schema_simple_content])

        expect(models.length).to eq(3)

        expect(models[0].id).to eq('shoesize')
        expect(models[0].name).to eq('Shoesize')
        expect(models[0].root).to eq('shoesize')
        expect(models[0].properties.length).to eq(2)
        expect(models[0].properties[0].mapping_name).to eq('content')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)
        expect(models[0].properties[1].mapping_name).to eq('country')
        expect(models[0].properties[1].type).to be_a(Shale::Schema::Compiler::Float)
        expect(models[0].properties[1].collection?).to eq(false)
        expect(models[0].properties[1].default).to eq(nil)
        expect(models[0].properties[1].prefix).to eq(nil)
        expect(models[0].properties[1].namespace).to eq(nil)

        expect(models[1].id).to eq('complex2')
        expect(models[1].name).to eq('Complex2')
        expect(models[1].root).to eq('complex2')
        expect(models[1].properties.length).to eq(2)
        expect(models[1].properties[0].mapping_name).to eq('content')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('el1')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[1].properties[1].collection?).to eq(false)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq(nil)
        expect(models[1].properties[1].namespace).to eq(nil)

        expect(models[2].id).to eq('complex1')
        expect(models[2].name).to eq('Complex1')
        expect(models[2].root).to eq('complex1')
        expect(models[2].properties.length).to eq(1)
        expect(models[2].properties[0].mapping_name).to eq('content')
        expect(models[2].properties[0].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[2].properties[0].collection?).to eq(false)
        expect(models[2].properties[0].default).to eq(nil)
        expect(models[2].properties[0].prefix).to eq(nil)
        expect(models[2].properties[0].namespace).to eq(nil)
      end
    end

    context 'with complex content' do
      it 'generates models' do
        models = described_class.new.as_models([schema_complex_content])

        expect(models.length).to eq(6)

        expect(models[0].id).to eq('RestrictedAddress')
        expect(models[0].name).to eq('RestrictedAddress')
        expect(models[0].root).to eq('RestrictedAddress')
        expect(models[0].properties.length).to eq(3)
        expect(models[0].properties[0].mapping_name).to eq('zip')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)
        expect(models[0].properties[1].mapping_name).to eq('Street')
        expect(models[0].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[1].collection?).to eq(false)
        expect(models[0].properties[1].default).to eq(nil)
        expect(models[0].properties[1].prefix).to eq(nil)
        expect(models[0].properties[1].namespace).to eq(nil)
        expect(models[0].properties[2].mapping_name).to eq('City')
        expect(models[0].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[2].collection?).to eq(false)
        expect(models[0].properties[2].default).to eq(nil)
        expect(models[0].properties[2].prefix).to eq(nil)
        expect(models[0].properties[2].namespace).to eq(nil)

        expect(models[1].id).to eq('Address')
        expect(models[1].name).to eq('Address')
        expect(models[1].root).to eq('Address')
        expect(models[1].properties.length).to eq(5)
        expect(models[1].properties[0].mapping_name).to eq('content')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('zip')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[1].collection?).to eq(false)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq(nil)
        expect(models[1].properties[1].namespace).to eq(nil)
        expect(models[1].properties[2].mapping_name).to eq('Street')
        expect(models[1].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[2].collection?).to eq(false)
        expect(models[1].properties[2].default).to eq(nil)
        expect(models[1].properties[2].prefix).to eq(nil)
        expect(models[1].properties[2].namespace).to eq(nil)
        expect(models[1].properties[3].mapping_name).to eq('City')
        expect(models[1].properties[3].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[3].collection?).to eq(false)
        expect(models[1].properties[3].default).to eq(nil)
        expect(models[1].properties[3].prefix).to eq(nil)
        expect(models[1].properties[3].namespace).to eq(nil)
        expect(models[1].properties[4].mapping_name).to eq('Country')
        expect(models[1].properties[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[4].collection?).to eq(false)
        expect(models[1].properties[4].default).to eq(nil)
        expect(models[1].properties[4].prefix).to eq(nil)
        expect(models[1].properties[4].namespace).to eq(nil)

        expect(models[2].id).to eq('ChildChildExtension')
        expect(models[2].name).to eq('ChildChildExtension')
        expect(models[2].root).to eq('ChildChildExtension')
        expect(models[2].properties.length).to eq(6)
        expect(models[2].properties[0].mapping_name).to eq('BaseAttribute1')
        expect(models[2].properties[0].type).to be_a(Shale::Schema::Compiler::Date)
        expect(models[2].properties[0].collection?).to eq(false)
        expect(models[2].properties[0].default).to eq(nil)
        expect(models[2].properties[0].prefix).to eq(nil)
        expect(models[2].properties[0].namespace).to eq(nil)
        expect(models[2].properties[1].mapping_name).to eq('BaseAttribute2')
        expect(models[2].properties[1].type).to be_a(Shale::Schema::Compiler::Time)
        expect(models[2].properties[1].collection?).to eq(false)
        expect(models[2].properties[1].default).to eq(nil)
        expect(models[2].properties[1].prefix).to eq(nil)
        expect(models[2].properties[1].namespace).to eq(nil)
        expect(models[2].properties[2].mapping_name).to eq('BaseElement1')
        expect(models[2].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[2].collection?).to eq(false)
        expect(models[2].properties[2].default).to eq(nil)
        expect(models[2].properties[2].prefix).to eq(nil)
        expect(models[2].properties[2].namespace).to eq(nil)
        expect(models[2].properties[3].mapping_name).to eq('BaseElement2')
        expect(models[2].properties[3].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[2].properties[3].collection?).to eq(false)
        expect(models[2].properties[3].default).to eq(nil)
        expect(models[2].properties[3].prefix).to eq(nil)
        expect(models[2].properties[3].namespace).to eq(nil)
        expect(models[2].properties[4].mapping_name).to eq('ChildElementA')
        expect(models[2].properties[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[4].collection?).to eq(false)
        expect(models[2].properties[4].default).to eq(nil)
        expect(models[2].properties[4].prefix).to eq(nil)
        expect(models[2].properties[4].namespace).to eq(nil)
        expect(models[2].properties[5].mapping_name).to eq('ChildElementC')
        expect(models[2].properties[5].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[5].collection?).to eq(false)
        expect(models[2].properties[5].default).to eq(nil)
        expect(models[2].properties[5].prefix).to eq(nil)
        expect(models[2].properties[5].namespace).to eq(nil)

        expect(models[3].id).to eq('ChildRestriction')
        expect(models[3].name).to eq('ChildRestriction')
        expect(models[3].root).to eq('ChildRestriction')
        expect(models[3].properties.length).to eq(3)
        expect(models[3].properties[0].mapping_name).to eq('BaseAttribute1')
        expect(models[3].properties[0].type).to be_a(Shale::Schema::Compiler::Date)
        expect(models[3].properties[0].collection?).to eq(false)
        expect(models[3].properties[0].default).to eq(nil)
        expect(models[3].properties[0].prefix).to eq(nil)
        expect(models[3].properties[0].namespace).to eq(nil)
        expect(models[3].properties[1].mapping_name).to eq('BaseAttribute2')
        expect(models[3].properties[1].type).to be_a(Shale::Schema::Compiler::Time)
        expect(models[3].properties[1].collection?).to eq(false)
        expect(models[3].properties[1].default).to eq(nil)
        expect(models[3].properties[1].prefix).to eq(nil)
        expect(models[3].properties[1].namespace).to eq(nil)
        expect(models[3].properties[2].mapping_name).to eq('ChildElementB')
        expect(models[3].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[3].properties[2].collection?).to eq(false)
        expect(models[3].properties[2].default).to eq(nil)
        expect(models[3].properties[2].prefix).to eq(nil)
        expect(models[3].properties[2].namespace).to eq(nil)

        expect(models[4].id).to eq('ChildExtension')
        expect(models[4].name).to eq('ChildExtension')
        expect(models[4].root).to eq('ChildExtension')
        expect(models[4].properties.length).to eq(5)
        expect(models[4].properties[0].mapping_name).to eq('BaseAttribute1')
        expect(models[4].properties[0].type).to be_a(Shale::Schema::Compiler::Date)
        expect(models[4].properties[0].collection?).to eq(false)
        expect(models[4].properties[0].default).to eq(nil)
        expect(models[4].properties[0].prefix).to eq(nil)
        expect(models[4].properties[0].namespace).to eq(nil)
        expect(models[4].properties[1].mapping_name).to eq('BaseAttribute2')
        expect(models[4].properties[1].type).to be_a(Shale::Schema::Compiler::Time)
        expect(models[4].properties[1].collection?).to eq(false)
        expect(models[4].properties[1].default).to eq(nil)
        expect(models[4].properties[1].prefix).to eq(nil)
        expect(models[4].properties[1].namespace).to eq(nil)
        expect(models[4].properties[2].mapping_name).to eq('BaseElement1')
        expect(models[4].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[4].properties[2].collection?).to eq(false)
        expect(models[4].properties[2].default).to eq(nil)
        expect(models[4].properties[2].prefix).to eq(nil)
        expect(models[4].properties[2].namespace).to eq(nil)
        expect(models[4].properties[3].mapping_name).to eq('BaseElement2')
        expect(models[4].properties[3].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[4].properties[3].collection?).to eq(false)
        expect(models[4].properties[3].default).to eq(nil)
        expect(models[4].properties[3].prefix).to eq(nil)
        expect(models[4].properties[3].namespace).to eq(nil)
        expect(models[4].properties[4].mapping_name).to eq('ChildElementA')
        expect(models[4].properties[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[4].properties[4].collection?).to eq(false)
        expect(models[4].properties[4].default).to eq(nil)
        expect(models[4].properties[4].prefix).to eq(nil)
        expect(models[4].properties[4].namespace).to eq(nil)

        expect(models[5].id).to eq('MixedContent')
        expect(models[5].name).to eq('MixedContent')
        expect(models[5].root).to eq('MixedContent')
        expect(models[5].properties.length).to eq(5)
        expect(models[5].properties[0].mapping_name).to eq('BaseAttribute1')
        expect(models[5].properties[0].type).to be_a(Shale::Schema::Compiler::Date)
        expect(models[5].properties[0].collection?).to eq(false)
        expect(models[5].properties[0].default).to eq(nil)
        expect(models[5].properties[0].prefix).to eq(nil)
        expect(models[5].properties[0].namespace).to eq(nil)
        expect(models[5].properties[1].mapping_name).to eq('BaseAttribute2')
        expect(models[5].properties[1].type).to be_a(Shale::Schema::Compiler::Time)
        expect(models[5].properties[1].collection?).to eq(false)
        expect(models[5].properties[1].default).to eq(nil)
        expect(models[5].properties[1].prefix).to eq(nil)
        expect(models[5].properties[1].namespace).to eq(nil)
        expect(models[5].properties[2].mapping_name).to eq('BaseElement1')
        expect(models[5].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[5].properties[2].collection?).to eq(false)
        expect(models[5].properties[2].default).to eq(nil)
        expect(models[5].properties[2].prefix).to eq(nil)
        expect(models[5].properties[2].namespace).to eq(nil)
        expect(models[5].properties[3].mapping_name).to eq('BaseElement2')
        expect(models[5].properties[3].type).to be_a(Shale::Schema::Compiler::Integer)
        expect(models[5].properties[3].collection?).to eq(false)
        expect(models[5].properties[3].default).to eq(nil)
        expect(models[5].properties[3].prefix).to eq(nil)
        expect(models[5].properties[3].namespace).to eq(nil)
        expect(models[5].properties[4].mapping_name).to eq('content')
        expect(models[5].properties[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[5].properties[4].collection?).to eq(false)
        expect(models[5].properties[4].default).to eq(nil)
        expect(models[5].properties[4].prefix).to eq(nil)
        expect(models[5].properties[4].namespace).to eq(nil)
      end
    end

    context 'with duplicated names' do
      it 'generates models' do
        models = described_class.new.as_models([schema_duplicates])

        expect(models.length).to eq(4)

        expect(models[0].id).to eq('Billing/Address')
        expect(models[0].name).to eq('Address2')
        expect(models[0].root).to eq('Address')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('billing')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)

        expect(models[1].id).to eq('Billing')
        expect(models[1].name).to eq('Billing')
        expect(models[1].root).to eq('Billing')
        expect(models[1].properties.length).to eq(1)
        expect(models[1].properties[0].mapping_name).to eq('Address')
        expect(models[1].properties[0].type).to eq(models[0])
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)

        expect(models[2].id).to eq('Shipping/Address')
        expect(models[2].name).to eq('Address1')
        expect(models[2].root).to eq('Address')
        expect(models[2].properties.length).to eq(1)
        expect(models[2].properties[0].mapping_name).to eq('shipping')
        expect(models[2].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[2].properties[0].collection?).to eq(false)
        expect(models[2].properties[0].default).to eq(nil)
        expect(models[2].properties[0].prefix).to eq(nil)
        expect(models[2].properties[0].namespace).to eq(nil)

        expect(models[3].id).to eq('Shipping')
        expect(models[3].name).to eq('Shipping')
        expect(models[3].root).to eq('Shipping')
        expect(models[3].properties.length).to eq(1)
        expect(models[3].properties[0].mapping_name).to eq('Address')
        expect(models[3].properties[0].type).to eq(models[2])
        expect(models[3].properties[0].collection?).to eq(false)
        expect(models[3].properties[0].default).to eq(nil)
        expect(models[3].properties[0].prefix).to eq(nil)
        expect(models[3].properties[0].namespace).to eq(nil)
      end
    end

    context 'with circular references' do
      it 'generates models' do
        models = described_class.new.as_models([schema_circular_references])

        expect(models.length).to eq(2)

        expect(models[0].id).to eq('Type2')
        expect(models[0].name).to eq('Type2')
        expect(models[0].root).to eq('Type2')
        expect(models[0].properties.length).to eq(1)
        expect(models[0].properties[0].mapping_name).to eq('Type1')
        expect(models[0].properties[0].type).to eq(models[1])
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)

        expect(models[1].id).to eq('Type1')
        expect(models[1].name).to eq('Type1')
        expect(models[1].root).to eq('Type1')
        expect(models[1].properties.length).to eq(1)
        expect(models[1].properties[0].mapping_name).to eq('Type2')
        expect(models[1].properties[0].type).to eq(models[0])
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
      end
    end

    context 'with collections' do
      it 'generates models' do
        models = described_class.new.as_models([schema_collections])

        expect(models.length).to eq(2)

        expect(models[0].id).to eq('complex2')
        expect(models[0].name).to eq('Complex2')
        expect(models[0].root).to eq('complex2')
        expect(models[0].properties.length).to eq(3)
        expect(models[0].properties[0].mapping_name).to eq('el1')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(true)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq(nil)
        expect(models[0].properties[0].namespace).to eq(nil)
        expect(models[0].properties[1].mapping_name).to eq('grup2-el1')
        expect(models[0].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[1].collection?).to eq(true)
        expect(models[0].properties[1].default).to eq(nil)
        expect(models[0].properties[1].prefix).to eq(nil)
        expect(models[0].properties[1].namespace).to eq(nil)
        expect(models[0].properties[2].mapping_name).to eq('top-el1')
        expect(models[0].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[2].collection?).to eq(true)
        expect(models[0].properties[2].default).to eq(nil)
        expect(models[0].properties[2].prefix).to eq(nil)
        expect(models[0].properties[2].namespace).to eq(nil)

        expect(models[1].id).to eq('complex1')
        expect(models[1].name).to eq('Complex1')
        expect(models[1].root).to eq('complex1')
        expect(models[1].properties.length).to eq(4)
        expect(models[1].properties[0].mapping_name).to eq('el1')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(true)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('grup1-el1')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[1].collection?).to eq(true)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq(nil)
        expect(models[1].properties[1].namespace).to eq(nil)
        expect(models[1].properties[2].mapping_name).to eq('grup2-el1')
        expect(models[1].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[2].collection?).to eq(true)
        expect(models[1].properties[2].default).to eq(nil)
        expect(models[1].properties[2].prefix).to eq(nil)
        expect(models[1].properties[2].namespace).to eq(nil)
        expect(models[1].properties[3].mapping_name).to eq('top-el1')
        expect(models[1].properties[3].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[3].collection?).to eq(true)
        expect(models[1].properties[3].default).to eq(nil)
        expect(models[1].properties[3].prefix).to eq(nil)
        expect(models[1].properties[3].namespace).to eq(nil)
      end
    end

    context 'with namespaces' do
      it 'generates models' do
        models = described_class.new.as_models([schema_namespaces1, schema_namespaces2])

        expect(models.length).to eq(2)

        expect(models[0].id).to eq('http://foo.com:Address')
        expect(models[0].name).to eq('Address')
        expect(models[0].root).to eq('Address')
        expect(models[0].prefix).to eq('foo')
        expect(models[0].namespace).to eq('http://foo.com')
        expect(models[0].properties.length).to eq(3)
        expect(models[0].properties[0].mapping_name).to eq('Number')
        expect(models[0].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[0].collection?).to eq(false)
        expect(models[0].properties[0].default).to eq(nil)
        expect(models[0].properties[0].prefix).to eq('foo')
        expect(models[0].properties[0].namespace).to eq('http://foo.com')
        expect(models[0].properties[1].mapping_name).to eq('City')
        expect(models[0].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[1].collection?).to eq(false)
        expect(models[0].properties[1].default).to eq(nil)
        expect(models[0].properties[1].prefix).to eq('foo')
        expect(models[0].properties[1].namespace).to eq('http://foo.com')
        expect(models[0].properties[2].mapping_name).to eq('Street')
        expect(models[0].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[0].properties[2].collection?).to eq(false)
        expect(models[0].properties[2].default).to eq(nil)
        expect(models[0].properties[2].prefix).to eq('foo')
        expect(models[0].properties[2].namespace).to eq('http://foo.com')

        expect(models[1].id).to eq('http://bar.com:Person')
        expect(models[1].name).to eq('Person')
        expect(models[1].root).to eq('Person')
        expect(models[1].prefix).to eq('bar')
        expect(models[1].namespace).to eq('http://bar.com')
        expect(models[1].properties.length).to eq(7)
        expect(models[1].properties[0].mapping_name).to eq('age')
        expect(models[1].properties[0].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[0].collection?).to eq(false)
        expect(models[1].properties[0].default).to eq(nil)
        expect(models[1].properties[0].prefix).to eq(nil)
        expect(models[1].properties[0].namespace).to eq(nil)
        expect(models[1].properties[1].mapping_name).to eq('lang')
        expect(models[1].properties[1].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[1].collection?).to eq(false)
        expect(models[1].properties[1].default).to eq(nil)
        expect(models[1].properties[1].prefix).to eq('foo')
        expect(models[1].properties[1].namespace).to eq('http://foo.com')
        expect(models[1].properties[2].mapping_name).to eq('pet')
        expect(models[1].properties[2].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[2].collection?).to eq(false)
        expect(models[1].properties[2].default).to eq(nil)
        expect(models[1].properties[2].prefix).to eq('bar')
        expect(models[1].properties[2].namespace).to eq('http://bar.com')
        expect(models[1].properties[3].mapping_name).to eq('FirstName')
        expect(models[1].properties[3].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[3].collection?).to eq(false)
        expect(models[1].properties[3].default).to eq(nil)
        expect(models[1].properties[3].prefix).to eq('bar')
        expect(models[1].properties[3].namespace).to eq('http://bar.com')
        expect(models[1].properties[4].mapping_name).to eq('LastName')
        expect(models[1].properties[4].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[4].collection?).to eq(false)
        expect(models[1].properties[4].default).to eq(nil)
        expect(models[1].properties[4].prefix).to eq('bar')
        expect(models[1].properties[4].namespace).to eq('http://bar.com')
        expect(models[1].properties[5].mapping_name).to eq('foobar')
        expect(models[1].properties[5].type).to be_a(Shale::Schema::Compiler::String)
        expect(models[1].properties[5].collection?).to eq(false)
        expect(models[1].properties[5].default).to eq(nil)
        expect(models[1].properties[5].prefix).to eq('bar')
        expect(models[1].properties[5].namespace).to eq('http://bar.com')
        expect(models[1].properties[6].mapping_name).to eq('Address')
        expect(models[1].properties[6].type).to eq(models[0])
        expect(models[1].properties[6].collection?).to eq(false)
        expect(models[1].properties[6].default).to eq(nil)
        expect(models[1].properties[6].prefix).to eq('foo')
        expect(models[1].properties[6].namespace).to eq('http://foo.com')
      end
    end
  end

  describe '#to_models' do
    let(:schema) do
      <<~DATA
        <xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">
          <xs:element name="root" type="root" />

          <xs:complexType name="root">
            <xs:sequence>
              <xs:element name="name" type="xs:string" />
            </xs:sequence>
          </xs:complexType>
        </xs:schema>
      DATA
    end

    let(:result) do
      <<~DATA
        require 'shale'

        class Root < Shale::Mapper
          attribute :name, Shale::Type::String

          xml do
            root 'root'

            map_element 'name', to: :name
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
