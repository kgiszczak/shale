# frozen_string_literal: true

require 'shale/schema/compiler/string'

RSpec.describe Shale::Schema::Compiler::String do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::String')
    end
  end
end
