# frozen_string_literal: true

module MiniActiveSupport
  module Hash
    # @return [Hash<String, Object>]
    def as_json
      transform_keys(&:to_s).transform_values(&:as_json)
    end

    # @return [String]
    def to_json
      JSON.dump(as_json)
    end
  end
end
