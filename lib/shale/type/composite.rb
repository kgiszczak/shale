# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    # Build composite object. Don't use it directly.
    # It serves as a base type class for @see Shale::Mapper
    #
    # @api private
    class Composite < Base
      class << self
        # Convert Hash to Object
        #
        # @param [Hash] hash Hash to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def out_of_hash(hash)
          instance = new

          hash.each do |key, value|
            mapping = hash_mapping.keys[key]
            next unless mapping

            if mapping.is_a?(Hash)
              instance.send(mapping[:from], value)
            else
              attribute = attributes[mapping]
              next unless attribute

              if value.nil?
                instance.public_send("#{attribute.name}=", nil)
                next
              end

              if attribute.collection?
                [*value].each do |val|
                  val = val ? attribute.type.out_of_hash(val) : val
                  instance.public_send(attribute.name) << attribute.type.cast(val)
                end
              else
                instance.public_send("#{attribute.name}=", attribute.type.out_of_hash(value))
              end
            end
          end

          instance
        end

        alias from_hash out_of_hash

        # Convert Object to Hash
        #
        # @param [Shale::Type::Base] instance Object to convert
        #
        # @return [Hash]
        #
        # @api public
        def as_hash(instance)
          hash = {}

          instance.class.hash_mapping.keys.each do |key, attr|
            if attr.is_a?(Hash)
              hash[key] = instance.send(attr[:to])
            else
              attribute = instance.class.attributes[attr]
              next unless attribute

              value = instance.public_send(attribute.name)

              if value.nil?
                hash[key] = nil
                next
              end

              if attribute.collection?
                hash[key] = [*value].map { |v| v ? attribute.type.as_hash(v) : v }
              else
                hash[key] = attribute.type.as_hash(value)
              end
            end
          end

          hash
        end

        alias to_hash as_hash

        # Convert JSON document to Object
        #
        # @param [Hash] hash JSON document to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def out_of_json(hash)
          instance = new

          hash.each do |key, value|
            mapping = json_mapping.keys[key]
            next unless mapping

            if mapping.is_a?(Hash)
              instance.send(mapping[:from], value)
            else
              attribute = attributes[mapping]
              next unless attribute

              if value.nil?
                instance.public_send("#{attribute.name}=", nil)
                next
              end

              if attribute.collection?
                [*value].each do |val|
                  val = val ? attribute.type.out_of_json(val) : val
                  instance.public_send(attribute.name) << attribute.type.cast(val)
                end
              else
                instance.public_send("#{attribute.name}=", attribute.type.out_of_json(value))
              end
            end
          end

          instance
        end

        # Convert JSON to Object
        #
        # @param [String] json JSON to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def from_json(json)
          out_of_json(Shale.json_adapter.load(json))
        end

        # Convert Object to JSON document
        #
        # @param [Shale::Type::Base] instance Object to convert
        #
        # @return [Hash]
        #
        # @api public
        def as_json(instance)
          hash = {}

          instance.class.json_mapping.keys.each do |key, attr|
            if attr.is_a?(Hash)
              hash[key] = instance.send(attr[:to])
            else
              attribute = instance.class.attributes[attr]
              next unless attribute

              value = instance.public_send(attribute.name)

              if value.nil?
                hash[key] = nil
                next
              end

              if attribute.collection?
                hash[key] = [*value].map { |v| v ? attribute.type.as_json(v) : v }
              else
                hash[key] = attribute.type.as_json(value)
              end
            end
          end

          hash
        end

        # Convert Object to JSON
        #
        # @param [Shale::Type::Base] instance Object to convert
        #
        # @return [String]
        #
        # @api public
        def to_json(instance)
          Shale.json_adapter.dump(as_json(instance))
        end

        # Convert YAML document to Object
        #
        # @param [Hash] hash YAML document to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def out_of_yaml(hash)
          instance = new

          hash.each do |key, value|
            mapping = yaml_mapping.keys[key]
            next unless mapping

            if mapping.is_a?(Hash)
              instance.send(mapping[:from], value)
            else
              attribute = attributes[mapping]
              next unless attribute

              if value.nil?
                instance.public_send("#{attribute.name}=", nil)
                next
              end

              if attribute.collection?
                [*value].each do |val|
                  val = val ? attribute.type.out_of_yaml(val) : val
                  instance.public_send(attribute.name) << attribute.type.cast(val)
                end
              else
                instance.public_send("#{attribute.name}=", attribute.type.out_of_yaml(value))
              end
            end
          end

          instance
        end

        # Convert YAML to Object
        #
        # @param [String] yaml YAML to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def from_yaml(yaml)
          out_of_yaml(Shale.yaml_adapter.load(yaml))
        end

        # Convert Object to YAML document
        #
        # @param [Shale::Type::Base] instance Object to convert
        #
        # @return [Hash]
        #
        # @api public
        def as_yaml(instance)
          hash = {}

          instance.class.yaml_mapping.keys.each do |key, attr|
            if attr.is_a?(Hash)
              hash[key] = instance.send(attr[:to])
            else
              attribute = instance.class.attributes[attr]
              next unless attribute

              value = instance.public_send(attribute.name)

              if value.nil?
                hash[key] = nil
                next
              end

              if attribute.collection?
                hash[key] = [*value].map { |v| v ? attribute.type.as_yaml(v) : v }
              else
                hash[key] = attribute.type.as_yaml(value)
              end
            end
          end

          hash
        end

        # Convert Object to YAML
        #
        # @param [Shale::Type::Base] instance Object to convert
        #
        # @return [String]
        #
        # @api public
        def to_yaml(instance)
          Shale.yaml_adapter.dump(as_yaml(instance))
        end

        # Convert XML document to Object
        #
        # @param [Shale::Adapter::<XML adapter>::Node] xml XML to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def out_of_xml(element)
          instance = new

          element.attributes.each do |key, value|
            mapping = xml_mapping.attributes[key.to_s]
            next unless mapping

            if mapping.is_a?(Hash)
              instance.send(mapping[:from], value)
            else
              attribute = attributes[mapping]
              next unless attribute

              if attribute.collection?
                instance.public_send(attribute.name) << attribute.type.cast(value)
              else
                instance.public_send("#{attribute.name}=", value)
              end
            end
          end

          if xml_mapping.content
            attribute = attributes[xml_mapping.content]

            if attribute
              instance.public_send("#{attribute.name}=", attribute.type.out_of_xml(element))
            end
          end

          element.children.each do |node|
            mapping = xml_mapping.elements[node.name]
            next unless mapping

            if mapping.is_a?(Hash)
              instance.send(mapping[:from], node)
            else
              attribute = attributes[mapping]
              next unless attribute

              if attribute.collection?
                value = attribute.type.out_of_xml(node)
                instance.public_send(attribute.name) << attribute.type.cast(value)
              else
                instance.public_send("#{attribute.name}=", attribute.type.out_of_xml(node))
              end
            end
          end

          instance
        end

        # Convert XML to Object
        #
        # @param [String] xml XML to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def from_xml(xml)
          out_of_xml(Shale.xml_adapter.load(xml))
        end

        # Convert Object to XML document
        #
        # @param [Shale::Type::Base] instance Object to convert
        # @param [String, nil] node_name XML node name
        # @param [Shale::Adapter::<xml adapter>::Document, nil] doc Object to convert
        #
        # @return [::REXML::Document, ::Nokogiri::Document, ::Ox::Document]
        #
        # @api public
        def as_xml(instance, node_name = nil, doc = nil)
          unless doc
            doc = Shale.xml_adapter.create_document
            doc.add_element(doc.doc, as_xml(instance, instance.class.xml_mapping.root, doc))
            return doc.doc
          end

          element = doc.create_element(node_name)

          xml_mapping.attributes.each do |xml_attr, obj_attr|
            if obj_attr.is_a?(Hash)
              instance.send(obj_attr[:to], element, doc)
            else
              attribute = instance.class.attributes[obj_attr]
              next unless attribute

              value = instance.public_send(attribute.name)

              if value && !value.empty?
                doc.add_attribute(element, xml_attr, value)
              end
            end
          end

          if xml_mapping.content
            attribute = instance.class.attributes[xml_mapping.content]

            if attribute
              value = instance.public_send(attribute.name)
              doc.add_text(element, value.to_s) if value
            end
          end

          xml_mapping.elements.each do |xml_name, obj_attr|
            if obj_attr.is_a?(Hash)
              instance.send(obj_attr[:to], element, doc)
            else
              attribute = instance.class.attributes[obj_attr]
              next unless attribute

              value = instance.public_send(attribute.name)
              next if value.nil?

              if attribute.collection?
                [*value].each do |v|
                  next if v.nil?
                  doc.add_element(element, attribute.type.as_xml(v, xml_name, doc))
                end
              else
                doc.add_element(element, attribute.type.as_xml(value, xml_name, doc))
              end
            end
          end

          element
        end

        # Convert Object to XML
        #
        # @param [Shale::Type::Base] instance Object to convert
        #
        # @return [String]
        #
        # @api public
        def to_xml(instance)
          Shale.xml_adapter.dump(as_xml(instance))
        end
      end

      # Convert Object to Hash
      #
      # @return [Hash]
      #
      # @api public
      def to_hash
        self.class.to_hash(self)
      end

      # Convert Object to JSON
      #
      # @return [String]
      #
      # @api public
      def to_json
        self.class.to_json(self)
      end

      # Convert Object to YAML
      #
      # @return [String]
      #
      # @api public
      def to_yaml
        self.class.to_yaml(self)
      end

      # Convert Object to XML
      #
      # @return [String]
      #
      # @api public
      def to_xml
        self.class.to_xml(self)
      end
    end
  end
end
