# frozen_string_literal: true

require 'shale/schema/compiler/integer'

RSpec.describe Shale::Schema::Compiler::Integer do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Integer')
    end
  end
end
