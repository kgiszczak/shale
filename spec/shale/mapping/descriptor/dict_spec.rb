# frozen_string_literal: true

require 'shale/mapping/descriptor/dict'

RSpec.describe Shale::Mapping::Descriptor::Dict do
  describe '#name' do
    it 'returns name' do
      obj = described_class.new(
        name: 'foo',
        attribute: :bar,
        methods: nil,
        render_nil: false
      )
      expect(obj.name).to eq('foo')
    end
  end

  describe '#attribute' do
    context 'when attribute is set' do
      it 'returns attribute' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: nil,
          render_nil: false
        )
        expect(obj.attribute).to eq(:bar)
      end
    end

    context 'when attribute is not set' do
      it 'returns nil' do
        obj = described_class.new(
          name: 'foo',
          attribute: nil,
          methods: nil,
          render_nil: false
        )
        expect(obj.attribute).to eq(nil)
      end
    end
  end

  describe '#method_from' do
    context 'when object was initialized with methods argument' do
      it 'returns method_from' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: { from: :met_from, to: :met_to },
          render_nil: false
        )
        expect(obj.method_from).to eq(:met_from)
      end
    end

    context 'when object was initialized without methods argument' do
      it 'returns nil' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: nil,
          render_nil: false
        )
        expect(obj.method_from).to eq(nil)
      end
    end
  end

  describe '#method_to' do
    context 'when object was initialized with methods argument' do
      it 'returns method_to' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: { from: :met_from, to: :met_to },
          render_nil: false
        )
        expect(obj.method_to).to eq(:met_to)
      end
    end

    context 'when object was initialized without methods argument' do
      it 'returns nil' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: nil,
          render_nil: false
        )
        expect(obj.method_to).to eq(nil)
      end
    end
  end

  describe '#render_nil?' do
    context 'when render_nil was set to true' do
      it 'returns true' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: nil,
          render_nil: true
        )
        expect(obj.render_nil?).to eq(true)
      end
    end

    context 'when render_nil was set to false' do
      it 'returns false' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: nil,
          render_nil: false
        )
        expect(obj.render_nil?).to eq(false)
      end
    end

    context 'when render_nil was set to nil' do
      it 'returns false' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: nil,
          render_nil: nil
        )
        expect(obj.render_nil?).to eq(false)
      end
    end

    context 'when render_nil was set to other value' do
      it 'returns false' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          methods: nil,
          render_nil: 'foobar'
        )
        expect(obj.render_nil?).to eq(false)
      end
    end
  end
end
