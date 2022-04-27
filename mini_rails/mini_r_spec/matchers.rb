# frozen_string_literal: true

module MiniRSpec
  # NOTE: Mathcer object
  # Under the hood expect(1).to eq(1) is EqMatcher.new(1) == Matcher(1)
  # expect(1).not_to eq(2) is EqMatcher.new(2) != Matcher(1)
  # expect(1).to be_present is BePresentMatcher.new == Mather(1)
  class Matcher
    def initialize(value = nil)
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

  class BePresentMatcher < Matcher
    def ==(new_value)
      check_object(new_value)
      a = new_value.present?
      message = "'#{new_value}' does not present"
      raise MatchError, message if a == false
      a
    end

    def !=(new_value)
      check_object(new_value)
      a = !new_value.present?
      message = "'#{new_value}' presents"
      raise MatchError, message if a == false
      a
    end

    private

    def check_object(new_value)
      unless new_value.respond_to?(:present?)
        raise MatchError, "'#{new_value}' doesn't respond to present?"
      end
    end
  end

  class HaveHttpStatusMatcher < Matcher
    def ==(new_value)
      a = new_value.status == @value
      message = "'#{new_value.status}' doesn't equal to #{@value}"
      raise MatchError, message if a == false
      a
    end

    def !=(new_value)
      a = new_value.status != @value
      message = "'#{new_value.status}' equals to #{@value}"
      raise MatchError, message if a == false
      a
    end
  end
end
