# frozen_string_literal: true

require 'shale/adapter/rack_url_encoded'

RSpec.describe Shale::Adapter::RackURLEncoded do
  describe '.load' do
    it 'parses urlencoded document' do
      doc = described_class.load('name=Alice&age=30')
      expect(doc).to eq({ 'name' => 'Alice', 'age' => '30' })
    end
  end

  describe '.dump' do
    it 'generates urlencoded document' do
      urlencoded = described_class.dump({ 'name' => 'Alice', 'age' => '30' })
      expect(urlencoded).to eq('name=Alice&age=30')
    end
  end
end
