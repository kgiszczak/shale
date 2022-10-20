# frozen_string_literal: true

require 'csv'

module Shale
  module Adapter
    # CSV adapter
    #
    # @api public
    class CSV
      # Parse CSV into Array<Hash<String, any>>
      #
      # @param [String] csv CSV document
      # @param [Array<String>] headers
      # @param [Hash] options
      #
      # @return [Array<Hash<String, any>>]
      #
      # @api private
      def self.load(csv, headers:, **options)
        ::CSV.parse(csv, headers: headers, **options).map(&:to_h)
      end

      # Serialize Array<Hash<String, any>> into CSV
      #
      # @param [Array<Hash<String, any>>] obj Array<Hash<String, any>> object
      # @param [Array<String>] headers
      # @param [Hash] options
      #
      # @return [String]
      #
      # @api private
      def self.dump(obj, headers:, **options)
        ::CSV.generate(**options) do |csv|
          obj.each do |row|
            values = []

            headers.each do |header|
              values << row[header] if row.key?(header)
            end

            csv << values
          end
        end
      end
    end
  end
end
