# frozen_string_literal: true

require 'shale/schema/json_generator/base'

module ShaleSchemaJSONGeneratorBaseTesting
  class TypeNullable < Shale::Schema::JSONGenerator::Base
    def as_type
      { 'type' => 'test-type' }
    end
  end

  class TypeNotNullable < Shale::Schema::JSONGenerator::Base
    def as_type
      { 'foo' => 'test-type' }
    end
  end

  class TypeMultipleValues < Shale::Schema::JSONGenerator::Base
    def as_type
      { 'type' => %w[test-type1 test-type2 test-type3] }
    end
  end
end

RSpec.describe Shale::Schema::JSONGenerator::Base do
  describe '#name' do
    it 'returns name' do
      expect(ShaleSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo').name).to eq('foo')
    end
  end

  describe '#as_json' do
    context 'when can by null' do
      context 'when is not nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'type' => 'test-type' })
        end
      end

      context 'when is nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type null] })
        end
      end

      context 'when is not nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo', default: 'foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'type' => 'test-type', 'default' => 'foo' })
        end
      end

      context 'when is nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNullable.new('foo', default: 'foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type null], 'default' => 'foo' })
        end
      end

      context 'when has multiple values' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeMultipleValues.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'type' => %w[test-type1 test-type2 test-type3 null] })
        end
      end
    end

    context 'when can not by null' do
      context 'when is not nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'foo' => 'test-type' })
        end
      end

      context 'when is nullable and has no default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'foo' => 'test-type' })
        end
      end

      context 'when is not nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo', default: 'foo')
          type.nullable = false

          expect(type.as_json).to eq({ 'foo' => 'test-type', 'default' => 'foo' })
        end
      end

      context 'when is nullable and has default' do
        it 'returns JSON Schema fragment as Hash' do
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo', default: 'foo')
          type.nullable = true

          expect(type.as_json).to eq({ 'foo' => 'test-type', 'default' => 'foo' })
        end
      end

      context 'when schema has required set to true' do
        it 'returns JSON Schema fragment as Hash' do
          schema = { required: true }
          type = ShaleSchemaJSONGeneratorBaseTesting::TypeNotNullable.new('foo', default: 'foo', schema: schema)

          expect(type.as_json).to eq({ 'foo' => 'test-type', 'default' => 'foo' })
        end
      end
    end
  end
end
