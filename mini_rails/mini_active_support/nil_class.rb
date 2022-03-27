# frozen_string_literal: true

module MiniActiveSupport
  module NilClass
    # @return [NilClass]
    def as_json
      self
    end

    # @return [NilClass]
    def to_json
      self
    end
  end
end
