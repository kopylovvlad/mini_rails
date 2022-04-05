# frozen_string_literal: true

module MiniActiveSupport
  module TrueClass
    include Comparable

    def <=>(other)
      case other
      when FalseClass
        -1
      when TrueClass
        0
      else
        raise ArgumentError, "comparison of TrueClass with #{other.class.name} failed"
      end
    end

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
