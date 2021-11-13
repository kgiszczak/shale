# frozen_string_literal: true

module Shale
  class Mapping
    def initialize
      @elements = {}
    end

    def map(element:, to:)
      @elements[element] = to
    end

    def [](val)
      @elements[val]
    end

    def elements(&block)
      @elements.each(&block)
    end

    def initialize_dup(other)
      @elements = other.instance_variable_get('@elements').dup
      super
    end
  end
end
