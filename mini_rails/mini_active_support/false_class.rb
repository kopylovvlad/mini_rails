# frozen_string_literal: true

module MiniActiveSupport
  module FalseClass
    # @return [FalseClass]
    def as_json
      self
    end

    # @return [FalseClass]
    def to_json
      self
    end
  end
end
