# frozen_string_literal: true

require 'shale/schema/compiler/time'

RSpec.describe Shale::Schema::Compiler::Time do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Time')
    end
  end
end
