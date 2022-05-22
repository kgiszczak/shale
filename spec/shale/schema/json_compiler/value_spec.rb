# frozen_string_literal: true

require 'shale/schema/json_compiler/value'

RSpec.describe Shale::Schema::JSONCompiler::Value do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Value')
    end
  end
end
