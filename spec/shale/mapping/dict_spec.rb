# frozen_string_literal: true

require 'shale/mapping/dict'

RSpec.describe Shale::Mapping::Dict do
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

    context 'when :receiver is not nil' do
      it 'adds mapping to keys hash' do
        obj = described_class.new
        obj.map('foo', to: :bar, receiver: :baz)

        expect(obj.keys.keys).to eq(['foo'])
        expect(obj.keys['foo'].receiver).to eq(:baz)
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

      context 'when :render_nil is set' do
        it 'adds mapping to keys hash' do
          obj = described_class.new
          obj.map('foo', to: :foo, render_nil: true)
          expect(obj.keys['foo'].render_nil?).to eq(true)
        end
      end
    end
  end

  describe '#render_nil' do
    it 'sets render_nil default' do
      obj = described_class.new
      obj.map('foo1', to: :foo1)
      expect(obj.keys['foo1'].render_nil?).to eq(false)

      obj.render_nil(true)
      obj.map('foo2', to: :foo2)
      expect(obj.keys['foo2'].render_nil?).to eq(true)
    end
  end

  describe '#group' do
    it 'creates methods mappings' do
      obj = described_class.new

      obj.map('foo', to: :foo)
      obj.group(from: :foo, to: :bar) do
        map('bar')
        map('baz')
      end

      expect(obj.keys.keys).to eq(%w[foo bar baz])
      expect(obj.keys['foo'].attribute).to eq(:foo)
      expect(obj.keys['foo'].method_from).to eq(nil)
      expect(obj.keys['foo'].method_to).to eq(nil)
      expect(obj.keys['foo'].group).to eq(nil)

      expect(obj.keys['bar'].attribute).to eq(nil)
      expect(obj.keys['bar'].method_from).to eq(:foo)
      expect(obj.keys['bar'].method_to).to eq(:bar)
      expect(obj.keys['bar'].group).to match('group_')

      expect(obj.keys['baz'].attribute).to eq(nil)
      expect(obj.keys['baz'].method_from).to eq(:foo)
      expect(obj.keys['baz'].method_to).to eq(:bar)
      expect(obj.keys['baz'].group).to match('group_')
    end
  end
end
