# frozen_string_literal: true

require 'shale/schema/json/string'

RSpec.describe Shale::Schema::JSON::String do
  describe '#as_type' do
    it 'returns JSON Schema fragment as Hash' do
      expect(described_class.new('foo').as_type).to eq({ 'type' => 'string' })
    end
  end
end
