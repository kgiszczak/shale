# frozen_string_literal: true

require 'shale/schema/json_compiler/float'

RSpec.describe Shale::Schema::JSONCompiler::Float do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Float')
    end
  end
end
