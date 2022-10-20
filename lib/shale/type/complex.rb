# frozen_string_literal: true

require_relative '../error'
require_relative '../mapping/group/dict_grouping'
require_relative '../mapping/group/xml_grouping'
require_relative 'value'

module Shale
  module Type
    # Build complex object. Don't use it directly.
    # It serves as a base type class for @see Shale::Mapper
    #
    # @api private
    class Complex < Value
      class << self
        %i[hash json yaml toml csv].each do |format|
          class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
            # Convert Hash to Object using Hash/JSON/YAML/TOML mapping
            #
            # @param [Hash, Array] hash Hash to convert
            # @param [Array<Symbol>] only
            # @param [Array<Symbol>] except
            # @param [any] context
            #
            # @return [model instance]
            #
            # @api public
            def of_#{format}(hash, only: nil, except: nil, context: nil)
              #{
                if format != :toml
                  <<~CODE
                    if hash.is_a?(Array)
                      return hash.map do |item|
                        of_#{format}(item, only: only, except: except, context: context)
                      end
                    end
                  CODE
                end
              }

              instance = model.new

              attributes
                .values
                .select { |attr| attr.default }
                .each { |attr| instance.send(attr.setter, attr.default.call) }

              mapping_keys = #{format}_mapping.keys
              grouping = Shale::Mapping::Group::DictGrouping.new

              only = to_partial_render_attributes(only)
              except = to_partial_render_attributes(except)

              hash.each do |key, value|
                mapping = mapping_keys[key]
                next unless mapping

                if mapping.group
                  grouping.add(mapping, value)
                elsif mapping.method_from
                  mapper = new

                  if mapper.method(mapping.method_from).arity == 3
                    mapper.send(mapping.method_from, instance, value, context)
                  else
                    mapper.send(mapping.method_from, instance, value)
                  end
                else
                  attribute = attributes[mapping.attribute]
                  next unless attribute

                  if only
                    attribute_only = only[attribute.name]
                    next unless only.key?(attribute.name)
                  end

                  if except
                    attribute_except = except[attribute.name]
                    next if except.key?(attribute.name) && attribute_except.nil?
                  end

                  if value.nil?
                    instance.send(attribute.setter, nil)
                  elsif attribute.collection?
                    [*value].each do |val|
                      if val
                        val = attribute.type.of_#{format}(
                          val,
                          only: attribute_only,
                          except: attribute_except,
                          context: context
                        )
                      end

                      instance.send(attribute.name) << attribute.type.cast(val)
                    end
                  else
                    val = attribute.type.of_#{format}(
                      value,
                      only: attribute_only,
                      except: attribute_except,
                      context: context
                    )
                    instance.send(attribute.setter, attribute.type.cast(val))
                  end
                end
              end

              grouping.each do |group|
                mapper = new

                if mapper.method(group.method_from).arity == 3
                  mapper.send(group.method_from, instance, group.dict, context)
                else
                  mapper.send(group.method_from, instance, group.dict)
                end
              end

              instance
            end

            # Convert Object to Hash using Hash/JSON/YAML/TOML mapping
            #
            # @param [any, Array<any>] instance Object to convert
            # @param [Array<Symbol>] only
            # @param [Array<Symbol>] except
            # @param [any] context
            #
            # @raise [IncorrectModelError]
            #
            # @return [Hash]
            #
            # @api public
            def as_#{format}(instance, only: nil, except: nil, context: nil)
              #{
                if format != :toml
                  <<~CODE
                    if instance.is_a?(Array)
                      return instance.map do |item|
                        as_#{format}(item, only: only, except: except, context: context)
                      end
                    end
                  CODE
                end
              }

              unless instance.is_a?(model)
                msg = "argument is a '\#{instance.class}' but should be a '\#{model}'"
                raise IncorrectModelError, msg
              end

              hash = {}
              grouping = Shale::Mapping::Group::DictGrouping.new

              only = to_partial_render_attributes(only)
              except = to_partial_render_attributes(except)

              #{format}_mapping.keys.each_value do |mapping|
                if mapping.group
                  grouping.add(mapping, nil)
                elsif mapping.method_to
                  mapper = new

                  if mapper.method(mapping.method_to).arity == 3
                    mapper.send(mapping.method_to, instance, hash, context)
                  else
                    mapper.send(mapping.method_to, instance, hash)
                  end
                else
                  attribute = attributes[mapping.attribute]
                  next unless attribute

                  if only
                    attribute_only = only[attribute.name]
                    next unless only.key?(attribute.name)
                  end

                  if except
                    attribute_except = except[attribute.name]
                    next if except.key?(attribute.name) && attribute_except.nil?
                  end

                  value = instance.send(attribute.name)

                  if value.nil?
                    hash[mapping.name] = nil if mapping.render_nil?
                  elsif attribute.collection?
                    hash[mapping.name] = [*value].map do |val|
                      if val
                        attribute.type.as_#{format}(
                          val,
                          only: attribute_only,
                          except: attribute_except,
                          context: context
                        )
                      else
                        val
                      end
                    end
                  else
                    hash[mapping.name] = attribute.type.as_#{format}(
                      value,
                      only: attribute_only,
                      except: attribute_except,
                      context: context
                    )
                  end
                end
              end

              grouping.each do |group|
                mapper = new

                if mapper.method(group.method_to).arity == 3
                  mapper.send(group.method_to, instance, hash, context)
                else
                  mapper.send(group.method_to, instance, hash)
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
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @return [model instance]
        #
        # @api public
        def from_json(json, only: nil, except: nil, context: nil)
          of_json(
            Shale.json_adapter.load(json),
            only: only,
            except: except,
            context: context
          )
        end

        # Convert Object to JSON
        #
        # @param [model instance] instance Object to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        # @param [true, false] pretty
        #
        # @return [String]
        #
        # @api public
        def to_json(instance, only: nil, except: nil, context: nil, pretty: false)
          Shale.json_adapter.dump(
            as_json(instance, only: only, except: except, context: context),
            pretty: pretty
          )
        end

        # Convert YAML to Object
        #
        # @param [String] yaml YAML to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @return [model instance]
        #
        # @api public
        def from_yaml(yaml, only: nil, except: nil, context: nil)
          of_yaml(
            Shale.yaml_adapter.load(yaml),
            only: only,
            except: except,
            context: context
          )
        end

        # Convert Object to YAML
        #
        # @param [model instance] instance Object to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @return [String]
        #
        # @api public
        def to_yaml(instance, only: nil, except: nil, context: nil)
          Shale.yaml_adapter.dump(
            as_yaml(instance, only: only, except: except, context: context)
          )
        end

        # Convert TOML to Object
        #
        # @param [String] toml TOML to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @return [model instance]
        #
        # @api public
        def from_toml(toml, only: nil, except: nil, context: nil)
          validate_toml_adapter
          of_toml(
            Shale.toml_adapter.load(toml),
            only: only,
            except: except,
            context: context
          )
        end

        # Convert Object to TOML
        #
        # @param [model instance] instance Object to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @return [String]
        #
        # @api public
        def to_toml(instance, only: nil, except: nil, context: nil)
          validate_toml_adapter
          Shale.toml_adapter.dump(
            as_toml(instance, only: only, except: except, context: context)
          )
        end

        # Convert CSV to Object
        #
        # @param [String] csv CSV to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        # @param [true, false] headers
        # @param [Hash] csv_options
        #
        # @return [model instance]
        #
        # @api public
        def from_csv(csv, only: nil, except: nil, context: nil, headers: false, **csv_options)
          data = Shale.csv_adapter.load(csv, **csv_options.merge(headers: csv_mapping.keys.keys))

          data.shift if headers

          of_csv(
            data,
            only: only,
            except: except,
            context: context
          )
        end

        # Convert Object to CSV
        #
        # @param [model instance] instance Object to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        # @param [true, false] headers
        # @param [Hash] csv_options
        #
        # @return [String]
        #
        # @api public
        def to_csv(instance, only: nil, except: nil, context: nil, headers: false, **csv_options)
          data = as_csv([*instance], only: only, except: except, context: context)

          cols = csv_mapping.keys.values

          if only
            cols = cols.select { |e| only.include?(e.attribute) }
          end

          if except
            cols = cols.reject { |e| except.include?(e.attribute) }
          end

          cols = cols.map(&:name)

          if headers
            data.prepend(cols.to_h { |e| [e, e] })
          end

          Shale.csv_adapter.dump(data, **csv_options.merge(headers: cols))
        end

        # Convert XML document to Object
        #
        # @param [Shale::Adapter::<XML adapter>::Node] element
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @return [model instance]
        #
        # @api public
        def of_xml(element, only: nil, except: nil, context: nil)
          instance = model.new

          attributes
            .values
            .select { |attr| attr.default }
            .each { |attr| instance.send(attr.setter, attr.default.call) }

          grouping = Shale::Mapping::Group::XmlGrouping.new

          only = to_partial_render_attributes(only)
          except = to_partial_render_attributes(except)

          element.attributes.each do |key, value|
            mapping = xml_mapping.attributes[key.to_s]
            next unless mapping

            if mapping.group
              grouping.add(mapping, :attribute, value)
            elsif mapping.method_from
              mapper = new

              if mapper.method(mapping.method_from).arity == 3
                mapper.send(mapping.method_from, instance, value, context)
              else
                mapper.send(mapping.method_from, instance, value)
              end
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              next if only && !only.key?(attribute.name)
              next if except&.key?(attribute.name)

              if attribute.collection?
                instance.send(attribute.name) << attribute.type.cast(value)
              else
                instance.send(attribute.setter, attribute.type.cast(value))
              end
            end
          end

          content_mapping = xml_mapping.content

          if content_mapping
            if content_mapping.group
              grouping.add(content_mapping, :content, element)
            elsif content_mapping.method_from
              mapper = new

              if mapper.method(content_mapping.method_from).arity == 3
                mapper.send(content_mapping.method_from, instance, element, context)
              else
                mapper.send(content_mapping.method_from, instance, element)
              end
            else
              attribute = attributes[content_mapping.attribute]

              if attribute
                skip = false

                # rubocop:disable Metrics/BlockNesting
                skip = true if only && !only.key?(attribute.name)
                skip = true if except&.key?(attribute.name)

                unless skip
                  value = attribute.type.of_xml(element)
                  instance.send(attribute.setter, attribute.type.cast(value))
                end
                # rubocop:enable Metrics/BlockNesting
              end
            end
          end

          element.children.each do |node|
            mapping = xml_mapping.elements[node.name]
            next unless mapping

            if mapping.group
              grouping.add(mapping, :element, node)
            elsif mapping.method_from
              mapper = new

              if mapper.method(mapping.method_from).arity == 3
                mapper.send(mapping.method_from, instance, node, context)
              else
                mapper.send(mapping.method_from, instance, node)
              end
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              if only
                attribute_only = only[attribute.name]
                next unless only.key?(attribute.name)
              end

              if except
                attribute_except = except[attribute.name]
                next if except.key?(attribute.name) && attribute_except.nil?
              end

              value = attribute.type.of_xml(
                node,
                only: attribute_only,
                except: attribute_except,
                context: context
              )

              if attribute.collection?
                instance.send(attribute.name) << attribute.type.cast(value)
              else
                instance.send(attribute.setter, attribute.type.cast(value))
              end
            end
          end

          grouping.each do |group|
            mapper = new

            if mapper.method(group.method_from).arity == 3
              mapper.send(group.method_from, instance, group.dict, context)
            else
              mapper.send(group.method_from, instance, group.dict)
            end
          end

          instance
        end

        # Convert XML to Object
        #
        # @param [String] xml XML to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @raise [AdapterError]
        #
        # @return [model instance]
        #
        # @api public
        def from_xml(xml, only: nil, except: nil, context: nil)
          validate_xml_adapter
          of_xml(
            Shale.xml_adapter.load(xml),
            only: only,
            except: except,
            context: context
          )
        end

        # Convert Object to XML document
        #
        # @param [any] instance Object to convert
        # @param [String, nil] node_name XML node name
        # @param [Shale::Adapter::<xml adapter>::Document, nil] doc Object to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        #
        # @raise [IncorrectModelError]
        #
        # @return [::REXML::Document, ::Nokogiri::Document, ::Ox::Document]
        #
        # @api public
        def as_xml(
          instance,
          node_name = nil,
          doc = nil,
          _cdata = nil,
          only: nil,
          except: nil,
          context: nil,
          version: nil
        )
          unless instance.is_a?(model)
            msg = "argument is a '#{instance.class}' but should be a '#{model}'"
            raise IncorrectModelError, msg
          end

          unless doc
            doc = Shale.xml_adapter.create_document(version)

            element = as_xml(
              instance,
              xml_mapping.prefixed_root,
              doc,
              only: only,
              except: except,
              context: context
            )
            doc.add_element(doc.doc, element)

            return doc.doc
          end

          element = doc.create_element(node_name)

          doc.add_namespace(
            xml_mapping.default_namespace.prefix,
            xml_mapping.default_namespace.name
          )

          grouping = Shale::Mapping::Group::XmlGrouping.new

          only = to_partial_render_attributes(only)
          except = to_partial_render_attributes(except)

          xml_mapping.attributes.each_value do |mapping|
            if mapping.group
              grouping.add(mapping, :attribute, nil)
            elsif mapping.method_to
              mapper = new

              if mapper.method(mapping.method_to).arity == 4
                mapper.send(mapping.method_to, instance, element, doc, context)
              else
                mapper.send(mapping.method_to, instance, element, doc)
              end
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              next if only && !only.key?(attribute.name)
              next if except&.key?(attribute.name)

              value = instance.send(attribute.name)

              if mapping.render_nil? || !value.nil?
                doc.add_namespace(mapping.namespace.prefix, mapping.namespace.name)
                doc.add_attribute(element, mapping.prefixed_name, value)
              end
            end
          end

          content_mapping = xml_mapping.content

          if content_mapping
            if content_mapping.group
              grouping.add(content_mapping, :content, nil)
            elsif content_mapping.method_to
              mapper = new

              if mapper.method(content_mapping.method_to).arity == 4
                mapper.send(content_mapping.method_to, instance, element, doc, context)
              else
                mapper.send(content_mapping.method_to, instance, element, doc)
              end
            else
              attribute = attributes[content_mapping.attribute]

              if attribute
                skip = false

                # rubocop:disable Metrics/BlockNesting
                skip = true if only && !only.key?(attribute.name)
                skip = true if except&.key?(attribute.name)

                unless skip
                  value = instance.send(attribute.name)

                  if content_mapping.cdata
                    doc.create_cdata(value.to_s, element)
                  else
                    doc.add_text(element, value.to_s)
                  end
                end
                # rubocop:enable Metrics/BlockNesting
              end
            end
          end

          xml_mapping.elements.each_value do |mapping|
            if mapping.group
              grouping.add(mapping, :element, nil)
            elsif mapping.method_to
              mapper = new

              if mapper.method(mapping.method_to).arity == 4
                mapper.send(mapping.method_to, instance, element, doc, context)
              else
                mapper.send(mapping.method_to, instance, element, doc)
              end
            else
              attribute = attributes[mapping.attribute]
              next unless attribute

              if only
                attribute_only = only[attribute.name]
                next unless only.key?(attribute.name)
              end

              if except
                attribute_except = except[attribute.name]
                next if except.key?(attribute.name) && attribute_except.nil?
              end

              value = instance.send(attribute.name)

              if mapping.render_nil? || !value.nil?
                doc.add_namespace(mapping.namespace.prefix, mapping.namespace.name)
              end

              if value.nil?
                if mapping.render_nil?
                  child = doc.create_element(mapping.prefixed_name)
                  doc.add_element(element, child)
                end
              elsif attribute.collection?
                [*value].each do |v|
                  next if v.nil?
                  child = attribute.type.as_xml(
                    v,
                    mapping.prefixed_name,
                    doc,
                    mapping.cdata,
                    only: attribute_only,
                    except: attribute_except,
                    context: context
                  )
                  doc.add_element(element, child)
                end
              else
                child = attribute.type.as_xml(
                  value,
                  mapping.prefixed_name,
                  doc,
                  mapping.cdata,
                  only: attribute_only,
                  except: attribute_except,
                  context: context
                )
                doc.add_element(element, child)
              end
            end
          end

          grouping.each do |group|
            mapper = new

            if mapper.method(group.method_to).arity == 4
              mapper.send(group.method_to, instance, element, doc, context)
            else
              mapper.send(group.method_to, instance, element, doc)
            end
          end

          element
        end

        # Convert Object to XML
        #
        # @param [model instance] instance Object to convert
        # @param [Array<Symbol>] only
        # @param [Array<Symbol>] except
        # @param [any] context
        # @param [true, false] pretty
        # @param [true, false] declaration
        # @param [true, false, String] encoding
        #
        # @raise [AdapterError]
        #
        # @return [String]
        #
        # @api public
        def to_xml(
          instance,
          only: nil,
          except: nil,
          context: nil,
          pretty: false,
          declaration: false,
          encoding: false
        )
          validate_xml_adapter
          Shale.xml_adapter.dump(
            as_xml(instance, only: only, except: except, context: context, version: declaration),
            pretty: pretty,
            declaration: declaration,
            encoding: encoding
          )
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

        # Convert array with attributes to a hash
        #
        # @param [Array] ary
        #
        # @return [Hash, nil]
        #
        # @api private
        def to_partial_render_attributes(ary)
          return unless ary

          ary.each_with_object([]) do |e, obj|
            if e.is_a?(Hash)
              obj.push(*e.to_a)
            else
              obj.push([e, nil])
            end
          end.to_h
        end
      end

      # Convert Object to Hash
      #
      # @param [Array<Symbol>] only
      # @param [Array<Symbol>] except
      # @param [any] context
      #
      # @return [Hash]
      #
      # @api public
      def to_hash(only: nil, except: nil, context: nil)
        self.class.to_hash(self, only: only, except: except, context: context)
      end

      # Convert Object to JSON
      #
      # @param [Array<Symbol>] only
      # @param [Array<Symbol>] except
      # @param [any] context
      # @param [true, false] pretty
      #
      # @return [String]
      #
      # @api public
      def to_json(only: nil, except: nil, context: nil, pretty: false)
        self.class.to_json(
          self,
          only: only,
          except: except,
          context: context,
          pretty: pretty
        )
      end

      # Convert Object to YAML
      #
      # @param [Array<Symbol>] only
      # @param [Array<Symbol>] except
      # @param [any] context
      #
      # @return [String]
      #
      # @api public
      def to_yaml(only: nil, except: nil, context: nil)
        self.class.to_yaml(self, only: only, except: except, context: context)
      end

      # Convert Object to TOML
      #
      # @param [Array<Symbol>] only
      # @param [Array<Symbol>] except
      # @param [any] context
      #
      # @return [String]
      #
      # @api public
      def to_toml(only: nil, except: nil, context: nil)
        self.class.to_toml(self, only: only, except: except, context: context)
      end

      # Convert Object to CSV
      #
      # @param [Array<Symbol>] only
      # @param [Array<Symbol>] except
      # @param [any] context
      #
      # @return [String]
      #
      # @api public
      def to_csv(only: nil, except: nil, context: nil, headers: false, **csv_options)
        self.class.to_csv(
          self,
          only: only,
          except: except,
          context: context,
          headers: headers,
          **csv_options
        )
      end

      # Convert Object to XML
      #
      # @param [Array<Symbol>] only
      # @param [Array<Symbol>] except
      # @param [any] context
      # @param [true, false] pretty
      # @param [true, false] declaration
      # @param [true, false, String] encoding
      #
      # @return [String]
      #
      # @api public
      def to_xml(
        only: nil,
        except: nil,
        context: nil,
        pretty: false,
        declaration: false,
        encoding: false
      )
        self.class.to_xml(
          self,
          only: only,
          except: except,
          context: context,
          pretty: pretty,
          declaration: declaration,
          encoding: encoding
        )
      end
    end
  end
end
