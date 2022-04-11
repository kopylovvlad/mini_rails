# frozen_string_literal: true

module MiniActiveSupport
  module DateTime
    def present?
      true
    end

    # @return [String]
    def as_json
      to_s
    end

    # @return [String]
    def to_json
      as_json
    end
  end
end
