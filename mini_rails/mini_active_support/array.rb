# frozen_string_literal: true

module MiniActiveSupport
  module Array
    def empty?
      size == 0
    end

    def present?
      !empty?
    end

    def exclude?(object)
      !include?(object)
    end

    def exclude?(object)
      !include?(object)
    end

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
