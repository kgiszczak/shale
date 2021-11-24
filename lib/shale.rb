# frozen_string_literal: true

require 'yaml'

require 'shale/mapper'
require 'shale/adapter/json'
require 'shale/adapter/rexml'
require 'shale/type/boolean'
require 'shale/type/date'
require 'shale/type/float'
require 'shale/type/integer'
require 'shale/type/string'
require 'shale/type/time'
require 'shale/version'

module Shale
  class << self
    attr_writer :json_adapter, :yaml_adapter, :xml_adapter

    def json_adapter
      @json_adapter || Adapter::JSON
    end

    def yaml_adapter
      @yaml_adapter || YAML
    end

    def xml_adapter
      @xml_adapter || Adapter::REXML
    end
  end
end
