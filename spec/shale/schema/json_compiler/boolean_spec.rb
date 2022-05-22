# frozen_string_literal: true

require 'shale/schema/json_compiler/boolean'

RSpec.describe Shale::Schema::JSONCompiler::Boolean do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Boolean')
    end
  end
end
