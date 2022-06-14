# frozen_string_literal: true

require 'shale/schema/compiler/date'

RSpec.describe Shale::Schema::Compiler::Date do
  describe '#name' do
    it 'returns Shale type name' do
      expect(described_class.new.name).to eq('Shale::Type::Date')
    end
  end
end
