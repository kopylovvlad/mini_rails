# frozen_string_literal: true

module MiniActiveSupport
  module DateTime
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
