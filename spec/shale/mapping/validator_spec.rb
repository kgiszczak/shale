# frozen_string_literal: true

require 'shale/mapping/validator'

RSpec.describe Shale::Mapping::Validator do
  describe '.validate_arguments' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        expect do
          described_class.validate_arguments('key', nil, nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when using: { from: } is nil' do
      it 'raises an error' do
        expect do
          described_class.validate_arguments('key', nil, { to: :foo })
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when using: { to: } is nil' do
      it 'raises an error' do
        expect do
          described_class.validate_arguments('key', nil, { from: :foo })
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is present' do
      it 'returns nil' do
        result = described_class.validate_arguments('key', :foo, nil)
        expect(result).to eq(nil)
      end
    end

    context 'when :using is present' do
      it 'returns nil' do
        result = described_class.validate_arguments('key', nil, { from: :foo, to: :bar })
        expect(result).to eq(nil)
      end
    end
  end

  describe '.validate_namespace' do
    context 'when namespace and prefix is nil' do
      it 'returns nil' do
        result = described_class.validate_namespace('key', nil, nil)
        expect(result).to eq(nil)
      end
    end

    context 'when namespace and prefix is :undefined' do
      it 'returns nil' do
        result = described_class.validate_namespace('key', :undefined, :undefined)
        expect(result).to eq(nil)
      end
    end

    context 'when namespace is present but prefix is nil' do
      it 'raises an error' do
        expect do
          described_class.validate_namespace('key', 'nsp', nil)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace is present but prefix is :undefined' do
      it 'raises an error' do
        expect do
          described_class.validate_namespace('key', 'nsp', :undefined)
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when prefix is present but namespace is nil' do
      it 'raises an error' do
        expect do
          described_class.validate_namespace('key', nil, 'pfx')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when prefix is present but namespace is :undefined' do
      it 'raises an error' do
        expect do
          described_class.validate_namespace('key', :undefined, 'pfx')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when namespace and prefix is present' do
      it 'returns nil' do
        result = described_class.validate_namespace('key', 'nsp', 'pfx')
        expect(result).to eq(nil)
      end
    end
  end
end
