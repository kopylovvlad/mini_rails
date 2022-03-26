# frozen_string_literal: true

module MiniActiveSupport
  module Numeric
    # @return [Numeric]
    def as_json
      self
    end

    # @return [Numeric]
    def to_json
      self
    end
  end
end
