# frozen_string_literal: true

require 'shale/mapping/descriptor/dict'

RSpec.describe Shale::Mapping::Descriptor::Dict do
  describe '#name' do
    context 'when name is set' do
      it 'returns name' do
        obj = described_class.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false
        )
        expect(obj.name).to eq('foo')
      end
    end

    context 'when name is not set' do
      it 'returns nil' do
        obj = described_class.new(
          name: nil,
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false
        )
        expect(obj.name).to eq(nil)
      end
    end
  end

  describe '#attribute' do
    context 'when attribute is set' do
      it 'returns attribute' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          receiver: nil,
          methods: nil,
          group: nil,
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
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false
        )
        expect(obj.attribute).to eq(nil)
      end
    end
  end

  describe '#receiver' do
    context 'when receiver is set' do
      it 'returns receiver' do
        obj = described_class.new(
          name: 'foo',
          attribute: nil,
          receiver: :foo,
          methods: nil,
          group: nil,
          render_nil: false
        )
        expect(obj.receiver).to eq(:foo)
      end
    end

    context 'when receiver is not set' do
      it 'returns nil' do
        obj = described_class.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false
        )
        expect(obj.receiver).to eq(nil)
      end
    end
  end

  describe '#method_from' do
    context 'when object was initialized with methods argument' do
      it 'returns method_from' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          receiver: nil,
          methods: { from: :met_from, to: :met_to },
          group: nil,
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
          receiver: nil,
          methods: nil,
          group: nil,
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
          receiver: nil,
          methods: { from: :met_from, to: :met_to },
          group: nil,
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
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false
        )
        expect(obj.method_to).to eq(nil)
      end
    end
  end

  describe '#group' do
    context 'when group is set' do
      it 'returns group' do
        obj = described_class.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: 'foobar',
          render_nil: false
        )
        expect(obj.group).to eq('foobar')
      end
    end

    context 'when group is not set' do
      it 'returns nil' do
        obj = described_class.new(
          name: 'foo',
          attribute: nil,
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: false
        )
        expect(obj.group).to eq(nil)
      end
    end
  end

  describe '#render_nil?' do
    context 'when render_nil was set to true' do
      it 'returns true' do
        obj = described_class.new(
          name: 'foo',
          attribute: :bar,
          receiver: nil,
          methods: nil,
          group: nil,
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
          receiver: nil,
          methods: nil,
          group: nil,
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
          receiver: nil,
          methods: nil,
          group: nil,
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
          receiver: nil,
          methods: nil,
          group: nil,
          render_nil: 'foobar'
        )
        expect(obj.render_nil?).to eq(false)
      end
    end
  end
end
