# frozen_string_literal: true

require 'shale/error'

RSpec.describe Shale::UnknownAttributeError do
  describe '#initialize' do
    it 'initializes error with message' do
      error = described_class.new('record', 'attribute')
      expect(error.message).to eq("unknown attribute 'attribute' for record.")
    end
  end
end

RSpec.describe Shale::DefaultNotCallableError do
  describe '#initialize' do
    it 'initializes error with message' do
      error = described_class.new('record', 'attribute')
      expect(error.message).to eq("'attribute' default is not callable for record.")
    end
  end
end
