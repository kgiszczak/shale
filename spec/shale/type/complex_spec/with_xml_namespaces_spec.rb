# frozen_string_literal: true

require 'shale'
require 'shale/adapter/rexml'
require 'shale/adapter/csv'
require 'tomlib'

module ComplexSpec__XmlNamespaces # rubocop:disable Naming/ClassAndModuleCamelCase
  class NoNsDeclaration < Shale::Mapper
    attribute :attr_no_ns, Shale::Type::String
    attribute :attr_ns1, Shale::Type::String
    attribute :attr_ns2, Shale::Type::String
    attribute :el_no_ns, Shale::Type::String
    attribute :el_ns1, Shale::Type::String
    attribute :el_ns2, Shale::Type::String

    xml do
      root 'no_ns_declaration'

      map_attribute 'attr_no_ns', to: :attr_no_ns
      map_attribute 'attr_ns1', to: :attr_ns1, namespace: 'http://ns1.com', prefix: 'ns1'
      map_attribute 'attr_ns2', to: :attr_ns2, namespace: 'http://ns2.com', prefix: 'ns2'

      map_element 'el_no_ns', to: :el_no_ns
      map_element 'el_ns1', to: :el_ns1, namespace: 'http://ns1.com', prefix: 'ns1'
      map_element 'el_ns2', to: :el_ns2, namespace: 'http://ns2.com', prefix: 'ns2'
    end
  end

  class NsDeclaration < Shale::Mapper
    attribute :attr_no_ns, Shale::Type::String
    attribute :attr_ns1, Shale::Type::String
    attribute :attr_ns2, Shale::Type::String
    attribute :el_no_ns, Shale::Type::String
    attribute :el_ns1, Shale::Type::String
    attribute :el_ns2, Shale::Type::String

    xml do
      root 'ns_declaration'
      namespace 'http://ns1.com', 'ns1'

      map_attribute 'attr_no_ns', to: :attr_no_ns
      map_attribute 'attr_ns1', to: :attr_ns1, namespace: 'http://ns1.com', prefix: 'ns1'
      map_attribute 'attr_ns2', to: :attr_ns2, namespace: 'http://ns2.com', prefix: 'ns2'

      map_element 'el_no_ns', to: :el_no_ns, namespace: nil, prefix: nil
      map_element 'el_ns1', to: :el_ns1
      map_element 'el_ns2', to: :el_ns2, namespace: 'http://ns2.com', prefix: 'ns2'
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

  context 'with xml namespaces' do
    context 'with no default namespace' do
      describe '.from_xml' do
        let(:xml) do
          <<~DOC
            <no_ns_declaration
              attr_no_ns="attr_no_ns"
              ns1:attr_ns1="attr_ns1"
              ns2:attr_ns2="attr_ns2"
              xmlns:ns1="http://ns1.com"
              xmlns:ns2="http://ns2.com"
            >
              <el_no_ns>el_no_ns</el_no_ns>
              <ns1:el_ns1>el_ns1</ns1:el_ns1>
              <ns2:el_ns2>el_ns2</ns2:el_ns2>
            </no_ns_declaration>
          DOC
        end

        context 'with no ns declaration' do
          let(:mapper) { ComplexSpec__XmlNamespaces::NoNsDeclaration }

          it 'maps xml to object' do
            instance = mapper.from_xml(xml)

            expect(instance.attr_no_ns).to eq('attr_no_ns')
            expect(instance.attr_ns1).to eq('attr_ns1')
            expect(instance.attr_ns2).to eq('attr_ns2')
            expect(instance.el_no_ns).to eq('el_no_ns')
            expect(instance.el_ns1).to eq('el_ns1')
            expect(instance.el_ns2).to eq('el_ns2')
          end
        end

        context 'with ns declaration' do
          let(:mapper) { ComplexSpec__XmlNamespaces::NsDeclaration }

          it 'maps xml to object' do
            instance = mapper.from_xml(xml)

            expect(instance.attr_no_ns).to eq('attr_no_ns')
            expect(instance.attr_ns1).to eq('attr_ns1')
            expect(instance.attr_ns2).to eq('attr_ns2')
            expect(instance.el_no_ns).to eq('el_no_ns')
            expect(instance.el_ns1).to eq('el_ns1')
            expect(instance.el_ns2).to eq('el_ns2')
          end
        end
      end

      describe '.to_xml' do
        context 'with no ns declaration' do
          let(:mapper) { ComplexSpec__XmlNamespaces::NoNsDeclaration }

          let(:xml) do
            <<~DOC.gsub("\n", '').gsub(/\s+/, ' ').gsub('> <', '><')
              <no_ns_declaration
                attr_no_ns="attr_no_ns"
                ns1:attr_ns1="attr_ns1"
                ns2:attr_ns2="attr_ns2"
                xmlns:ns1="http://ns1.com"
                xmlns:ns2="http://ns2.com"
              >
                <el_no_ns>el_no_ns</el_no_ns>
                <ns1:el_ns1>el_ns1</ns1:el_ns1>
                <ns2:el_ns2>el_ns2</ns2:el_ns2>
              </no_ns_declaration>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              attr_no_ns: 'attr_no_ns',
              attr_ns1: 'attr_ns1',
              attr_ns2: 'attr_ns2',
              el_no_ns: 'el_no_ns',
              el_ns1: 'el_ns1',
              el_ns2: 'el_ns2'
            )

            expect(instance.to_xml).to eq(xml)
          end
        end

        context 'with ns declaration' do
          let(:mapper) { ComplexSpec__XmlNamespaces::NsDeclaration }

          let(:xml) do
            <<~DOC.gsub("\n", '').gsub(/\s+/, ' ').gsub('> <', '><')
              <ns1:ns_declaration
                attr_no_ns="attr_no_ns"
                ns1:attr_ns1="attr_ns1"
                ns2:attr_ns2="attr_ns2"
                xmlns:ns1="http://ns1.com"
                xmlns:ns2="http://ns2.com"
              >
                <el_no_ns>el_no_ns</el_no_ns>
                <ns1:el_ns1>el_ns1</ns1:el_ns1>
                <ns2:el_ns2>el_ns2</ns2:el_ns2>
              </ns1:ns_declaration>
            DOC
          end

          it 'converts objects to xml' do
            instance = mapper.new(
              attr_no_ns: 'attr_no_ns',
              attr_ns1: 'attr_ns1',
              attr_ns2: 'attr_ns2',
              el_no_ns: 'el_no_ns',
              el_ns1: 'el_ns1',
              el_ns2: 'el_ns2'
            )

            expect(instance.to_xml).to eq(xml)
          end
        end
      end
    end

    context 'with default namespace' do
      describe '.from_xml' do
        let(:xml) do
          <<~DOC
            <no_ns_declaration
              attr_no_ns="attr_no_ns"
              ns1:attr_ns1="attr_ns1"
              ns2:attr_ns2="attr_ns2"
              xmlns="http://ns1.com"
              xmlns:ns1="http://ns1.com"
              xmlns:ns2="http://ns2.com"
            >
              <el_no_ns xmlns="">el_no_ns</el_no_ns>
              <el_ns1>el_ns1</el_ns1>
              <ns2:el_ns2>el_ns2</ns2:el_ns2>
            </no_ns_declaration>
          DOC
        end

        context 'with no ns declaration' do
          let(:mapper) { ComplexSpec__XmlNamespaces::NoNsDeclaration }

          it 'maps xml to object' do
            instance = mapper.from_xml(xml)

            expect(instance.attr_no_ns).to eq('attr_no_ns')
            expect(instance.attr_ns1).to eq('attr_ns1')
            expect(instance.attr_ns2).to eq('attr_ns2')
            expect(instance.el_no_ns).to eq('el_no_ns')
            expect(instance.el_ns1).to eq('el_ns1')
            expect(instance.el_ns2).to eq('el_ns2')
          end
        end

        context 'with ns declaration' do
          let(:mapper) { ComplexSpec__XmlNamespaces::NsDeclaration }

          it 'maps xml to object' do
            instance = mapper.from_xml(xml)

            expect(instance.attr_no_ns).to eq('attr_no_ns')
            expect(instance.attr_ns1).to eq('attr_ns1')
            expect(instance.attr_ns2).to eq('attr_ns2')
            expect(instance.el_no_ns).to eq('el_no_ns')
            expect(instance.el_ns1).to eq('el_ns1')
            expect(instance.el_ns2).to eq('el_ns2')
          end
        end
      end
    end
  end
end
