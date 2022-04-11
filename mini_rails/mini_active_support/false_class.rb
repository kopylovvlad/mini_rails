# frozen_string_literal: true

module MiniActiveSupport
  module FalseClass
    include Comparable

    def <=>(other)
      case other
      when FalseClass
        0
      when TrueClass
        1
      else
        raise ArgumentError, "comparison of FalseClass with #{other.class.name} failed"
      end
    end

    def present?
      false
    end

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
