# frozen_string_literal: true

require 'json'

module Shale
  module Adapter
    class JSON
      def self.load(json)
        ::JSON.parse(json)
      end

      def self.dump(obj)
        ::JSON.generate(obj)
      end
    end
  end
end
