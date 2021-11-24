# frozen_string_literal: true

module Shale
  module Type
    class Base
      class << self
        def cast(value)
          value
        end

        def out_of_hash(value)
          value
        end

        def as_hash(value)
          value
        end

        def out_of_json(value)
          value
        end

        def as_json(value)
          value
        end

        def out_of_yaml(value)
          value
        end

        def as_yaml(value)
          value
        end

        def out_of_xml(node)
          node.text
        end

        def as_xml(value, name, doc)
          element = doc.create_element(name)
          doc.add_text(element, value.to_s)
          element
        end
      end
    end
  end
end
