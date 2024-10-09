# frozen_string_literal: true

require 'shale/error'

RSpec.describe Shale::UnknownAttributeError do
  describe 'inheritance' do
    it 'inherits from NoMethodError' do
      expect(Shale::UnknownAttributeError < NoMethodError).to eq(true)
    end
  end

  describe '#initialize' do
    it 'initializes error with message' do
      error = described_class.new('record', 'attribute')
      expect(error.message).to eq("unknown attribute 'attribute' for record.")
    end
  end
end

RSpec.describe Shale::DefaultNotCallableError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::DefaultNotCallableError < Shale::ShaleError).to eq(true)
    end
  end

  describe '#initialize' do
    it 'initializes error with message' do
      error = described_class.new('record', 'attribute')
      expect(error.message).to eq("'attribute' default is not callable for record.")
    end
  end
end

RSpec.describe Shale::IncorrectModelError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::IncorrectModelError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::IncorrectMappingArgumentsError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::IncorrectMappingArgumentsError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::NotAShaleMapperError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::NotAShaleMapperError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::NotATypeValueError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::NotATypeValueError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::UnknownTypeError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::UnknownTypeError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::AttributeNotDefinedError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::AttributeNotDefinedError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::SchemaError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::SchemaError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::ParseError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::ParseError < Shale::ShaleError).to eq(true)
    end
  end
end

RSpec.describe Shale::AdapterError do
  describe 'inheritance' do
    it 'inherits from Shale::ShaleError' do
      expect(Shale::AdapterError < Shale::ShaleError).to eq(true)
    end
  end
end
