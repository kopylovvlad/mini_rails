# frozen_string_literal: true

module MiniRSpec
  class Matcher
    def initialize(value)
      @value = value
    end

    def to(matcher)
      matcher == @value
    end

    def not_to(matcher)
      matcher != @value
    end
  end

  class EqMatcher < Matcher
    def ==(new_value)
      a = @value == new_value
      message = "'#{new_value}' does not equal '#{@value}'"
      raise MatchError, message if a == false
      a
    end

    def !=(new_value)
      a = @value != new_value
      message = "'#{new_value}' equals '#{@value}'"
      raise MatchError, message if a == false
      a
    end
  end

  class IncludeMatcher < Matcher
    def ==(new_value)
      a = new_value.include?(@value)
      message = "'#{new_value}' not to include '#{@value}'"
      raise MatchError, message if a == false
      a
    end

    def !=(new_value)
      a = !new_value.include?(@value)
      message = "'#{new_value}' includes '#{@value}'"
      raise MatchError, message if a == false
      a
    end
  end

  class BeInstanceOfMatcher < Matcher
    def ==(new_value)
      a = new_value.is_a?(@value)
      message = "'#{new_value}' is not instance of '#{@value}'"
      raise MatchError, message if a == false
      a
    end

    def !=(new_value)
      a = !new_value.is_a?(@value)
      message = "'#{new_value}' is an instance of '#{@value}'"
      raise MatchError, message if a == false
      a
    end
  end
end
