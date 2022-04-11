# frozen_string_literal: true

module MiniActiveSupport
  module Numeric
    def present?
      self > 0
    end

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
