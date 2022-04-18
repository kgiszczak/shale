# frozen_string_literal: true

require 'shale/schema/json/base'

module ShaleSchemaJSONBaseTesting
  class TypeNullable < Shale::Schema::JSON::Base
    def as_type
      { 'type' => 'test-type' }
    end
  end

  class TypeNotNullable < Shale::Schema::JSON::Base
    def as_type
      { 'foo' => 'test-type' }
    end
  end
end

RSpec.describe Shale::Schema::JSON::Base do
  describe '#name' do
    it 'returns name' do
      expect(ShaleSchemaJSONBaseTesting::TypeNullable.new('foo').name).to eq('foo')
    end
  end

  describe '#as_json' do
    context 'when can by null' do
      context 'when is not nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNullable.new('foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'type' => 'test-type' })
        end
      end

      context 'when is nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNullable.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type null] })
        end
      end

      context 'when is not nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNullable.new('foo', default: 'foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'type' => 'test-type', 'default' => 'foo' })
        end
      end

      context 'when is nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNullable.new('foo', default: 'foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type null], 'default' => 'foo' })
        end
      end
    end

    context 'when can not by null' do
      context 'when is not nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNotNullable.new('foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'foo' => 'test-type' })
        end
      end

      context 'when is nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNotNullable.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'foo' => 'test-type' })
        end
      end

      context 'when is not nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNotNullable.new('foo', default: 'foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'foo' => 'test-type', 'default' => 'foo' })
        end
      end

      context 'when is nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONBaseTesting::TypeNotNullable.new('foo', default: 'foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'foo' => 'test-type', 'default' => 'foo' })
        end
      end
    end
  end
end
