# frozen_string_literal: true

require 'shale/schema/compiler/boolean'

RSpec.describe Shale::Schema::Compiler::Boolean do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Boolean')
    end
  end
end
