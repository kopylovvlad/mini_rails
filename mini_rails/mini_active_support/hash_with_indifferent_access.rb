# frozen_string_literal: true

module MiniActiveSupport
  # It converts all strings to symbols
  class HashWithIndifferentAccess
    def initialize(hash)
      @raw_hash = hash.map do |key, value|
        key = key.to_sym if key.is_a?(::String)
        value = new(value) if value.is_a?(::Hash)

        { key => value }
      end.reduce(:merge)
    end

    # @param key [String, Symbol]
    def [](key)
      if key.is_a?(::String)
        @raw_hash[key.to_sym]
      else
        @raw_hash[key]
      end
    end

    def present?
      @raw_hash.keys.size > 0
    end

    # @param key [String, Symbol]
    def include?(key)
      if key.is_a?(::String)
        @raw_hash.include?(key.to_sym)
      else
        @raw_hash.include?(key)
      end
    end

    alias_method :key?, :include?
    alias_method :has_key?, :include?

    def to_h
      @raw_hash
    end

    private

    def method_missing(message, *args, &block)
      if @raw_hash.respond_to?(message)
        @raw_hash.send(message, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @raw_hash.respond_to?(method_name, include_private) || super
    end
  end
end
