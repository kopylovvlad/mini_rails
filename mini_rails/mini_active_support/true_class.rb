# frozen_string_literal: true

module MiniActiveSupport
  module TrueClass
    # @return [TrueClass]
    def as_json
      self
    end

    # @return [TrueClass]
    def to_json
      self
    end
  end
end
