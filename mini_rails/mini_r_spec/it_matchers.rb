# frozen_string_literal: true

module MiniRSpec
  module ItMatchers
    def expect(object)
      Matcher.new(object)
    end

    def eq(object)
      EqMatcher.new(object)
    end

    def be_truthy
      eq(true)
    end

    def be_present
      BePresentMatcher.new
    end

    def be_falsey
      eq(false)
    end

    def be_nil
      eq(nil)
    end

    def be_instance_of(object)
      BeInstanceOfMatcher.new(object)
    end

    alias_method :be_kind_of, :be_instance_of

    def include(object)
      IncludeMatcher.new(object)
    end
  end
end
