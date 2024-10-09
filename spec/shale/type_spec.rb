# frozen_string_literal: true

require 'shale/type'

module ShaleTypeTesting
  class ValidType < Shale::Type::Value
  end

  class ReplacementValidType < Shale::Type::Value
  end

  class InvalidType # rubocop:disable Lint/EmptyClass
  end
end

RSpec.describe Shale::Type do
  it 'registers a valid type value' do
    klass = ShaleTypeTesting::ValidType

    Shale::Type.register(:valid_type, klass)

    expect(Shale::Type.lookup(:valid_type)).to eq(klass)
  end

  context 'when registering a type value with an existing type' do
    before do
      Shale::Type.register(:valid_type, ShaleTypeTesting::ValidType)
    end

    it 'replaces the existing type' do
      replacement_klass = ShaleTypeTesting::ReplacementValidType

      Shale::Type.register(:valid_type, replacement_klass)

      expect(Shale::Type.lookup(:valid_type)).to eq(replacement_klass)
    end
  end

  context 'when registering an invalid type value' do
    it 'raises an error' do
      klass = ShaleTypeTesting::InvalidType

      expect do
        Shale::Type.register(:invalid_type, klass)
      end.to raise_error(Shale::NotATypeValueError)
    end
  end

  context 'when looking up an unregistered type value' do
    it 'raises an error' do
      expect do
        Shale::Type.lookup(:unknown_type)
      end.to raise_error(Shale::UnknownTypeError)
    end
  end
end
