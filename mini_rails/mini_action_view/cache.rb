# frozen_string_literal: true

module MiniActionView
  class Cache
    include ::Singleton

    attr_reader :caching_vews

    def initialize
      @caching_vews = {}
    end

    # @param key [String]
    def [](key)
      @caching_vews[key]
    end

    # @param key [String]
    def []=(key, value)
      @caching_vews[key] = value
    end

    # @param key [String]
    def include?(key)
      @caching_vews.include?(key)
    end

    alias_method :key?, :include?
    alias_method :has_key?, :include?
  end
end
