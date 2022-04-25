# frozen_string_literal: true

module MiniActionController
  # Class for wrapping rack params
  # You can use it as 'param' method in a controller
  class Parameters
    def initialize(raw_params = {})
      @hash = ::MiniActiveSupport::HashWithIndifferentAccess.new(raw_params)
    end

    # @param key [String, Symbol]
    def require(key)
      if @hash.key?(key)
        @hash[key]
      else
        raise "param is missing or the value is empty: #{key}"
      end
    end

    # @param args [Array<Object>]
    def permit(*args)
      @hash.slice(*args)
    end

    private

    def method_missing(message, *args, &block)
      if @hash.respond_to?(message)
        @hash.send(message, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @hash.respond_to?(method_name, include_private) || super
    end
  end
end
