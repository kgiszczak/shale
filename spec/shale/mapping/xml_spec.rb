# frozen_string_literal: true

require 'shale/mapping/xml'

RSpec.describe Shale::Mapping::Xml do
  describe '#elements' do
    it 'returns elements hash' do
      obj = described_class.new
      expect(obj.elements).to eq({})
    end
  end

  describe '#attributes' do
    it 'returns attributes hash' do
      obj = described_class.new
      expect(obj.attributes).to eq({})
    end
  end

  describe '#content' do
    it 'returns content value' do
      obj = described_class.new
      expect(obj.content).to eq(nil)
    end
  end

  describe '#map_element' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_element('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to elements hash' do
        obj = described_class.new
        obj.map_element('foo', to: :bar)
        expect(obj.elements).to eq('foo' => :bar)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_element('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_element('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to elements hash' do
          obj = described_class.new
          obj.map_element('foo', using: { from: :foo, to: :bar })
          expect(obj.elements).to eq('foo' => { from: :foo, to: :bar })
        end
      end
    end
  end

  describe '#map_attribute' do
    context 'when :to and :using is nil' do
      it 'raises an error' do
        obj = described_class.new

        expect do
          obj.map_attribute('foo')
        end.to raise_error(Shale::IncorrectMappingArgumentsError)
      end
    end

    context 'when :to is not nil' do
      it 'adds mapping to attributes hash' do
        obj = described_class.new
        obj.map_attribute('foo', to: :bar)
        expect(obj.attributes).to eq('foo' => :bar)
      end
    end

    context 'when :using is not nil' do
      context 'when using: { from: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_attribute('foo', using: { to: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when using: { to: } is nil' do
        it 'raises an error' do
          obj = described_class.new

          expect do
            obj.map_attribute('foo', using: { from: :foo })
          end.to raise_error(Shale::IncorrectMappingArgumentsError)
        end
      end

      context 'when :using is correct' do
        it 'adds mapping to attributes hash' do
          obj = described_class.new
          obj.map_attribute('foo', using: { from: :foo, to: :bar })
          expect(obj.attributes).to eq('foo' => { from: :foo, to: :bar })
        end
      end
    end
  end

  describe '#map_content' do
    it 'adds mapping to attributes hash' do
      obj = described_class.new
      obj.map_content(to: :bar)
      expect(obj.content).to eq(:bar)
    end
  end

  describe '#root' do
    it 'sets/reads the root variable' do
      obj = described_class.new
      obj.root('foo')
      expect(obj.root).to eq('foo')
    end
  end

  describe '#initialize_dup' do
    it 'duplicates instance variables' do
      original = described_class.new
      original.map_element('element', to: :element)
      original.map_attribute('attribute', to: :attribute)
      original.map_content(to: :content)
      original.root('root')

      duplicate = original.dup
      duplicate.map_element('element_dup', to: :element_dup)
      duplicate.map_attribute('attribute_dup', to: :attribute_dup)
      duplicate.map_content(to: :content_dup)
      duplicate.root('root_dup')

      expect(original.elements).to eq('element' => :element)
      expect(original.attributes).to eq('attribute' => :attribute)
      expect(original.content).to eq(:content)
      expect(original.root).to eq('root')

      expect(duplicate.elements).to(
        eq('element' => :element, 'element_dup' => :element_dup)
      )
      expect(duplicate.attributes).to(
        eq('attribute' => :attribute, 'attribute_dup' => :attribute_dup)
      )
      expect(duplicate.content).to eq(:content_dup)
      expect(duplicate.root).to eq('root_dup')
    end
  end
end
