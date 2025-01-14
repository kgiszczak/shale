# frozen_string_literal: true

require 'shale/schema/compiler/decimal'

RSpec.describe Shale::Schema::Compiler::Decimal do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Decimal')
    end
  end
end
