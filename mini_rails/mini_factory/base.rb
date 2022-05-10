# frozen_string_literal: true

module MiniFactory
  class Base
    include Singleton

    def initialize
      @factories = {} # Hash to store data about all factories
    end

    # @param factory_name [String, Symbol]
    # @param opts [Hash<Symbol, Object>]
    # @option opts [Object, String] :class
    def factory(factory_name, opts, &block)
      buidler = Builder.new(opts[:class])
      buidler.instance_exec(&block)
      @factories[factory_name.to_sym] = {
        count: 0, buidler: buidler,
      }
      nil
    end

    # NOTE: Did we define a factory ?
    # @param factory_name [String, Symbol]
    def factory?(factory_name)
      @factories.key?(factory_name.to_sym)
    end

    # @param factory_name [String, Symbol]
    # @param traits [Array<Symbol>]
    # @param opts [Hash<Symbol, Object>]
    def build_factory(factory_name, traits, opts)
      # Find MiniFactory::Builder instance
      buidler = @factories[factory_name.to_sym][:buidler]
      number = @factories[factory_name.to_sym][:count] + 1
      @factories[factory_name.to_sym][:count] += 1
      # Build new object
      buidler.build_object(number, traits, opts)
    end
  end
end
