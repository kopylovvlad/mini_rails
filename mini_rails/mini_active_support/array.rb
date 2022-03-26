# frozen_string_literal: true

module MiniActiveSupport
  module Array
    # @return [Array<Object>]
    def as_json
      map(&:as_json)
    end

    # @return [String]
    def to_json
      JSON.dump(as_json)
    end
  end
end
