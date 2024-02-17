# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__CDATA # rubocop:disable Naming/ClassAndModuleCamelCase
  class Child < Shale::Mapper
    attribute :element1, Shale::Type::String

    xml do
      root 'child'
      map_content to: :element1, cdata: true
    end
  end

  class Parent < Shale::Mapper
    attribute :element1, Shale::Type::String
    attribute :element2, Shale::Type::String, collection: true
    attribute :child, Child

    xml do
      root 'parent'

      map_element 'element1', to: :element1, cdata: true
      map_element 'element2', to: :element2, cdata: true
      map_element 'child', to: :child
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

  context 'with CDATA option' do
    let(:xml) do
      <<~XML.gsub(/\n\z/, '')
        <parent>
          <element1><![CDATA[foo]]></element1>
          <element2><![CDATA[one]]></element2>
          <element2><![CDATA[two]]></element2>
          <element2><![CDATA[three]]></element2>
          <child><![CDATA[child]]></child>
        </parent>
      XML
    end

    it 'maps xml to object' do
      instance = ComplexSpec__CDATA::Parent.from_xml(xml)

      expect(instance.element1).to eq('foo')
      expect(instance.element2).to eq(%w[one two three])
      expect(instance.child.element1).to eq('child')
    end

    it 'converts objects to xml' do
      instance = ComplexSpec__CDATA::Parent.new(
        element1: 'foo',
        element2: %w[one two three],
        child: ComplexSpec__CDATA::Child.new(element1: 'child')
      )

      expect(instance.to_xml(pretty: true)).to eq(xml)
    end
  end
end
