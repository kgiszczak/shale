# frozen_string_literal: true

module Shale
  module Utils
    def self.underscore(word)
      word
        .gsub(/([A-Z\d]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .downcase
    end
  end
end
