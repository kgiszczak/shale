# frozen_string_literal: true

module Shale
  class UnknownAttributeError < NoMethodError
    def initialize(record, attribute)
      super("unknown attribute '#{attribute}' for #{record}.")
    end
  end

  class DefaultNotCallableError < StandardError
    def initialize(record, attribute)
      super("'#{attribute}' default is not callable for #{record}.")
    end
  end
end
