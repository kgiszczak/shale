# frozen_string_literal: true

require 'shale/schema'

module ShaleSchemaTesting
  class Root < Shale::Mapper
    attribute :foo, Shale::Type::String
  end
end

RSpec.describe Shale::Schema do
  let(:expected_json_schema) do
    <<~DATA.gsub(/\n\z/, '')
      {
        "$schema": "https://json-schema.org/draft/2020-12/schema",
        "$ref": "#/$defs/ShaleSchemaTesting_Root",
        "$defs": {
          "ShaleSchemaTesting_Root": {
            "type": "object",
            "properties": {
              "foo": {
                "type": [
                  "string",
                  "null"
                ]
              }
            }
          }
        }
      }
    DATA
  end

  describe '.to_json' do
    it 'generates JSON schema' do
      schema = described_class.to_json(ShaleSchemaTesting::Root, pretty: true)
      expect(schema).to eq(expected_json_schema)
    end
  end
end
