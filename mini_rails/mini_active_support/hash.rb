# frozen_string_literal: true

module MiniActiveSupport
  module Hash
    # @return [Hash<String, Object>]
    def as_json
      transform_keys(&:to_s)
    end

    # @return [String]
    def to_json
      JSON.dump(as_json)
    end
  end
end
