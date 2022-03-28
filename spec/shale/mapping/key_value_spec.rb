# frozen_string_literal: true

require 'shale/mapping/key_value'

RSpec.describe Shale::Mapping::KeyValue do
  describe '#keys' do
    it 'returns keys hash' do
      obj = described_class.new
      expect(obj.keys).to eq({})
    end
  end

  describe '#map' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to keys hash' do
        obj = described_class.new
        obj.map('foo', to: :bar)

        expect(obj.keys.keys).to eq(['foo'])
        expect(obj.keys['foo'].attribute).to eq(:bar)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to keys hash' do
          obj = described_class.new
          obj.map('foo', using: { from: :foo, to: :bar })
          expect(obj.keys.keys).to eq(['foo'])
          expect(obj.keys['foo'].attribute).to eq(nil)
          expect(obj.keys['foo'].method_from).to eq(:foo)
          expect(obj.keys['foo'].method_to).to eq(:bar)
        end
      end
    end
  end

  describe '#initialize_dup' do
    it 'duplicates keys instance variable' do
      original = described_class.new
      original.map('foo', to: :bar)

      duplicate = original.dup
      duplicate.map('baz', to: :qux)

      expect(original.keys.keys).to eq(['foo'])
      expect(original.keys['foo'].attribute).to eq(:bar)

      expect(duplicate.keys.keys).to eq(%w[foo baz])
      expect(duplicate.keys['foo'].attribute).to eq(:bar)
      expect(duplicate.keys['baz'].attribute).to eq(:qux)
    end
  end
end
