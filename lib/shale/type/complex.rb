# frozen_string_literal: true

require_relative 'base'

module Shale
  module Type
    class Complex < Base
      class << self
        def out_of_hash(hash)
          instance = new

          hash.each do |key, value|
            mapping = hash_mapping[key]
            next unless mapping

            attribute = attributes[mapping]
            next unless attribute

            if attribute.collection?
              [*value].each do |val|
                val = attribute.type.out_of_hash(val)
                instance.public_send(attribute.name) << attribute.type.cast(val)
              end
            else
              instance.public_send("#{attribute.name}=", attribute.type.out_of_hash(value))
            end
          end

          instance
        end

        alias :from_hash :out_of_hash

        def as_hash(instance)
          hash = {}

          instance.class.hash_mapping.elements do |element, attr|
            attribute = instance.class.attributes[attr]
            next unless attribute

            value = instance.public_send(attribute.name)

            if attribute.collection?
              hash[element] = [*value].map { |v| attribute.type.as_hash(v) }
            else
              hash[element] = attribute.type.as_hash(value)
            end
          end

          hash
        end

        alias :to_hash :as_hash

        def out_of_json(hash)
          instance = new

          hash.each do |key, value|
            mapping = json_mapping[key.to_sym]
            next unless mapping

            attribute = attributes[mapping]
            next unless attribute

            if attribute.collection?
              [*value].each do |val|
                val = attribute.type.out_of_json(val)
                instance.public_send(attribute.name) << attribute.type.cast(val)
              end
            else
              instance.public_send("#{attribute.name}=", attribute.type.out_of_json(value))
            end
          end

          instance
        end

        def from_json(json)
          out_of_json(Shale.json_adapter.load(json))
        end

        def as_json(instance)
          hash = {}

          instance.class.json_mapping.elements do |element, attr|
            attribute = instance.class.attributes[attr]
            next unless attribute

            value = instance.public_send(attribute.name)

            if attribute.collection?
              hash[element] = [*value].map { |v| attribute.type.as_json(v) }
            else
              hash[element] = attribute.type.as_json(value)
            end
          end

          hash
        end

        def to_json(instance)
          Shale.json_adapter.dump(as_json(instance))
        end

        def out_of_yaml(hash)
          instance = new

          hash.each do |key, value|
            mapping = yaml_mapping[key.to_sym]
            next unless mapping

            attribute = attributes[mapping]
            next unless attribute

            if attribute.collection?
              [*value].each do |val|
                val = attribute.type.out_of_yaml(val)
                instance.public_send(attribute.name) << attribute.type.cast(val)
              end
            else
              instance.public_send("#{attribute.name}=", attribute.type.out_of_yaml(value))
            end
          end

          instance
        end

        def from_yaml(yaml)
          out_of_yaml(Shale.yaml_adapter.load(yaml))
        end

        def as_yaml(instance)
          hash = {}

          instance.class.yaml_mapping.elements do |element, attr|
            attribute = instance.class.attributes[attr]
            next unless attribute

            element = element.to_s
            value = instance.public_send(attribute.name)

            if attribute.collection?
              hash[element] = [*value].map { |v| attribute.type.as_yaml(v) }
            else
              hash[element] = attribute.type.as_yaml(value)
            end
          end

          hash
        end

        def to_yaml(instance)
          Shale.yaml_adapter.dump(as_yaml(instance))
        end
      end

      def to_hash
        self.class.to_hash(self)
      end

      def to_json
        self.class.to_json(self)
      end

      def to_yaml
        self.class.to_yaml(self)
      end
    end
  end
end
