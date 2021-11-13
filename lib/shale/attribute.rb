# frozen_string_literal: true

module Shale
  class Attribute
    attr_reader :name, :type, :default

    def initialize(name, type, collection, default)
      @name = name
      @type = type
      @collection = collection
      @default = collection ? -> { [] } : default
    end

    def collection?
      @collection == true
    end
  end
end
