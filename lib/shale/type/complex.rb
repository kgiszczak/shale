# frozen_string_literal: true

require_relative '../error'
require_relative 'value'

module Shale
  module Type
    # Build complex object. Don't use it directly.
    # It serves as a base type class for @see Shale::Mapper
    #
    # @api private
    class Complex < Value
      class << self
        %i[hash json yaml toml].each do |format|
          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            # Convert Hash to Object using Hash/JSON/YAML/TOML mapping
            #
            # @param [Hash] hash Hash to convert
            #
            # @return [Shale::Mapper]
            #
            # @api public
            def of_#{format}(hash)
              instance = model.new

              attributes
                .values
                .select { |attr| attr.default }
                .each { |attr| instance.send(attr.setter, attr.default.call) }

              mapping_keys = #{format}_mapping.keys

              hash.each do |key, value|
                mapping = mapping_keys[key]
                next unless mapping

                if mapping.method_from
                  new.send(mapping.method_from, instance, value)
                else
                  attribute = attributes[mapping.attribute]
                  next unless attribute

                  if value.nil?
                    instance.send(attribute.setter, nil)
                  elsif attribute.collection?
                    [*value].each do |val|
                      val = val ? attribute.type.of_#{format}(val) : val
                      instance.send(attribute.name) << attribute.type.cast(val)
                    end
                  else
                    val = attribute.type.of_#{format}(value)
                    instance.send(attribute.setter, attribute.type.cast(val))
                  end
                end
              end

              instance
            end

            # Convert Object to Hash using Hash/JSON/YAML/TOML mapping
            #
            # @param [any] instance Object to convert
            #
            # @raise [IncorrectModelError]
            #
            # @return [Hash]
            #
            # @api public
            def as_#{format}(instance)
              unless instance.is_a?(model)
                msg = "argument is a '\#{instance.class}' but should be a '\#{model}'"
                raise IncorrectModelError, msg
              end

              hash = {}

              #{format}_mapping.keys.each_value do |mapping|
                if mapping.method_to
                  hash[mapping.name] = new.send(mapping.method_to, instance)
                else
                  attribute = attributes[mapping.attribute]
                  next unless attribute

                  value = instance.send(attribute.name)

                  if value.nil?
                    hash[mapping.name] = nil
                  elsif attribute.collection?
                    hash[mapping.name] = [*value].map do |v|
                      v ? attribute.type.as_#{format}(v) : v
                    end
                  else
                    hash[mapping.name] = attribute.type.as_#{format}(value)
                  end
                end
              end

              hash
            end
          RUBY
        end

        alias from_hash of_hash

        alias to_hash as_hash

        # Convert JSON to Object
        #
        # @param [String] json JSON to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def from_json(json)
          of_json(Shale.json_adapter.load(json))
        end

        # Convert Object to JSON
        #
        # @param [Shale::Mapper] instance Object to convert
        # @param [Array<Symbol>] options
        #
        # @return [String]
        #
        # @api public
        def to_json(instance, *options)
          Shale.json_adapter.dump(as_json(instance), *options)
        end

        # Convert YAML to Object
        #
        # @param [String] yaml YAML to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def from_yaml(yaml)
          of_yaml(Shale.yaml_adapter.load(yaml))
        end

        # Convert Object to YAML
        #
        # @param [Shale::Mapper] instance Object to convert
        #
        # @return [String]
        #
        # @api public
        def to_yaml(instance)
          Shale.yaml_adapter.dump(as_yaml(instance))
        end

        # Convert TOML to Object
        #
        # @param [String] toml TOML to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def from_toml(toml)
          validate_toml_adapter
          of_toml(Shale.toml_adapter.load(toml))
        end

        # Convert Object to TOML
        #
        # @param [Shale::Mapper] instance Object to convert
        #
        # @return [String]
        #
        # @api public
        def to_toml(instance)
          validate_toml_adapter
          Shale.toml_adapter.dump(as_toml(instance))
        end

        # Convert XML document to Object
        #
        # @param [Shale::Adapter::<XML adapter>::Node] xml XML to convert
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def of_xml(element)
          instance = model.new

          attributes
            .values
            .select { |attr| attr.default }
            .each { |attr| instance.send(attr.setter, attr.default.call) }

          element.attributes.each do |key, value|
            mapping = xml_mapping.attributes[key.to_s]
            next unless mapping

            if mapping.method_from
              new.send(mapping.method_from, instance, value)
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              if attribute.collection?
                instance.send(attribute.name) << attribute.type.cast(value)
              else
                instance.send(attribute.setter, attribute.type.cast(value))
              end
            end
          end

          content_mapping = xml_mapping.content

          if content_mapping
            if content_mapping.method_from
              new.send(content_mapping.method_from, instance, element)
            else
              attribute = attributes[content_mapping.attribute]

              if attribute
                value = attribute.type.of_xml(element)
                instance.send(attribute.setter, attribute.type.cast(value))
              end
            end
          end

          element.children.each do |node|
            mapping = xml_mapping.elements[node.name]
            next unless mapping

            if mapping.method_from
              new.send(mapping.method_from, instance, node)
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              value = attribute.type.of_xml(node)

              if attribute.collection?
                instance.send(attribute.name) << attribute.type.cast(value)
              else
                instance.send(attribute.setter, attribute.type.cast(value))
              end
            end
          end

          instance
        end

        # Convert XML to Object
        #
        # @param [String] xml XML to convert
        #
        # @raise [AdapterError]
        #
        # @return [Shale::Mapper]
        #
        # @api public
        def from_xml(xml)
          validate_xml_adapter
          of_xml(Shale.xml_adapter.load(xml))
        end

        # Convert Object to XML document
        #
        # @param [any] instance Object to convert
        # @param [String, nil] node_name XML node name
        # @param [Shale::Adapter::<xml adapter>::Document, nil] doc Object to convert
        #
        # @raise [IncorrectModelError]
        #
        # @return [::REXML::Document, ::Nokogiri::Document, ::Ox::Document]
        #
        # @api public
        def as_xml(instance, node_name = nil, doc = nil, _cdata = nil)
          unless instance.is_a?(model)
            msg = "argument is a '#{instance.class}' but should be a '#{model}'"
            raise IncorrectModelError, msg
          end

          unless doc
            doc = Shale.xml_adapter.create_document
            doc.add_element(doc.doc, as_xml(instance, xml_mapping.prefixed_root, doc))
            return doc.doc
          end

          element = doc.create_element(node_name)

          doc.add_namespace(
            xml_mapping.default_namespace.prefix,
            xml_mapping.default_namespace.name
          )

          xml_mapping.attributes.each_value do |mapping|
            if mapping.method_to
              new.send(mapping.method_to, instance, element, doc)
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              value = instance.send(attribute.name)
              next if value.nil?

              doc.add_namespace(mapping.namespace.prefix, mapping.namespace.name)
              doc.add_attribute(element, mapping.prefixed_name, value)
            end
          end

          content_mapping = xml_mapping.content

          if content_mapping
            if content_mapping.method_to
              new.send(content_mapping.method_to, instance, element, doc)
            else
              attribute = attributes[content_mapping.attribute]

              if attribute
                value = instance.send(attribute.name)

                # rubocop:disable Metrics/BlockNesting
                if content_mapping.cdata
                  doc.create_cdata(value.to_s, element)
                else
                  doc.add_text(element, value.to_s)
                end
                # rubocop:enable Metrics/BlockNesting
              end
            end
          end

          xml_mapping.elements.each_value do |mapping|
            if mapping.method_to
              new.send(mapping.method_to, instance, element, doc)
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              value = instance.send(attribute.name)
              next if value.nil?

              doc.add_namespace(mapping.namespace.prefix, mapping.namespace.name)

              if attribute.collection?
                [*value].each do |v|
                  next if v.nil?
                  child = attribute.type.as_xml(v, mapping.prefixed_name, doc, mapping.cdata)
                  doc.add_element(element, child)
                end
              else
                child = attribute.type.as_xml(value, mapping.prefixed_name, doc, mapping.cdata)
                doc.add_element(element, child)
              end
            end
          end

          element
        end

        # Convert Object to XML
        #
        # @param [Shale::Mapper] instance Object to convert
        # @param [Array<Symbol>] options
        #
        # @raise [AdapterError]
        #
        # @return [String]
        #
        # @api public
        def to_xml(instance, *options)
          validate_xml_adapter
          Shale.xml_adapter.dump(as_xml(instance), *options)
        end

        private

        # Validate TOML adapter
        #
        # @raise [AdapterError]
        #
        # @api private
        def validate_toml_adapter
          raise AdapterError, TOML_ADAPTER_NOT_SET_MESSAGE unless Shale.toml_adapter
        end

        # Validate XML adapter
        #
        # @raise [AdapterError]
        #
        # @api private
        def validate_xml_adapter
          raise AdapterError, XML_ADAPTER_NOT_SET_MESSAGE unless Shale.xml_adapter
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
      # @param [Array<Symbol>] options
      #
      # @return [String]
      #
      # @api public
      def to_json(*options)
        self.class.to_json(self, *options)
      end

      # Convert Object to YAML
      #
      # @return [String]
      #
      # @api public
      def to_yaml
        self.class.to_yaml(self)
      end

      # Convert Object to TOML
      #
      # @return [String]
      #
      # @api public
      def to_toml
        self.class.to_toml(self)
      end

      # Convert Object to XML
      #
      # @param [Array<Symbol>] options
      #
      # @return [String]
      #
      # @api public
      def to_xml(*options)
        self.class.to_xml(self, *options)
      end
    end
  end
end
