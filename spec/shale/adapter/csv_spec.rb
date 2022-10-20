# frozen_string_literal: true

require 'shale/adapter/csv'

RSpec.describe Shale::Adapter::CSV do
  describe '.load' do
    let(:headers) { %w[Foo Bar] }

    context 'without extra options' do
      it 'parses CSV document' do
        doc = described_class.load(<<~CSV, headers: headers)
          one,two
          three,four
        CSV

        expect(doc.length).to eq(2)
        expect(doc[0]).to eq({ 'Foo' => 'one', 'Bar' => 'two' })
        expect(doc[1]).to eq({ 'Foo' => 'three', 'Bar' => 'four' })
      end
    end

    context 'without extra options' do
      it 'passes extra options to the parser' do
        doc = described_class.load(<<~CSV, headers: headers, col_sep: '|')
          one|two
          three|four
        CSV

        expect(doc.length).to eq(2)
        expect(doc[0]).to eq({ 'Foo' => 'one', 'Bar' => 'two' })
        expect(doc[1]).to eq({ 'Foo' => 'three', 'Bar' => 'four' })
      end
    end
  end

  describe '.dump' do
    let(:headers) { %w[one two three] }
    let(:data) do
      [
        { 'two' => 2, 'one' => 1, 'three' => 3 },
        { 'three' => 3, 'one' => 1, 'two' => 2 },
      ]
    end

    context 'without extra options' do
      it 'generates CSV document preserving columns order' do
        csv = described_class.dump(data, headers: headers)
        expect(csv).to eq(<<~CSV)
          1,2,3
          1,2,3
        CSV
      end
    end

    context 'without extra options' do
      it 'passes extra options to the parser' do
        csv = described_class.dump(data, headers: headers, col_sep: '|')
        expect(csv).to eq(<<~CSV)
          1|2|3
          1|2|3
        CSV
      end
    end
  end
end
