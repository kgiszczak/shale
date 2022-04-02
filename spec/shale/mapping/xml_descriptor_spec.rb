# frozen_string_literal: true

require 'shale/mapping/xml_descriptor'
require 'shale/mapping/xml_namespace'

RSpec.describe Shale::Mapping::XmlDescriptor do
  describe '#prefixed_name' do
    context 'when prefix is present' do
      it 'returns name prefixed by namespace prefix' do
        obj = described_class.new(
          name: 'foo',
          attribute: :foo,
          methods: nil,
          namespace: Shale::Mapping::XmlNamespace.new('http://bar.com', 'bar')
        )

        expect(obj.prefixed_name).to eq('bar:foo')
      end
    end

    context 'when prefix is not present' do
      it 'returns name' do
        obj = described_class.new(
          name: 'foo',
          attribute: :foo,
          methods: nil,
          namespace: Shale::Mapping::XmlNamespace.new
        )

        expect(obj.prefixed_name).to eq('foo')
      end
    end
  end
end
