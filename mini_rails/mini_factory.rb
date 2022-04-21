# frozen_string_literal: true

# require 'singleton'
# require 'date'
# require 'byebug'
# require_relative 'mini_active_support.rb'

require_relative 'mini_factory/base'
require_relative 'mini_factory/builder'

module MiniFactory
  class << self
    def define(&block)
      Base.instance.instance_exec(&block)
    end

    # @param factory_name [Symbol, String]
    # @param traits_and_opts [Array]
    def build(factory_name, *traits_and_opts)
      unless Base.instance.factory?(factory_name)
        raise "ERROR: Undefined factory #{factory_name}"
      end
      opts = traits_and_opts.extract_options!
      traits = traits_and_opts.map(&:to_sym)
      Base.instance.build_factory(factory_name, traits, opts)
    end

    # @param factory_name [Symbol, String]
    # @param count [Integer]
    # @param traits_and_opts [Array]
    def build_list(factory_name, count, *traits_and_opts)
      Array.new(count).map do |_|
        build(factory_name, *traits_and_opts)
      end
    end

    # @param factory_name [Symbol, String]
    # @param traits_and_opts [Array]
    def create(factory_name, *traits_and_opts)
      item = build(factory_name, *traits_and_opts)
      item.save!
      item
    end

    # @param factory_name [Symbol, String]
    # @param count [Integer]
    # @param traits_and_opts [Array]
    def create_list(factory_name, count, *traits_and_opts)
      Array.new(count).map do |_|
        create(factory_name, *traits_and_opts)
      end
    end
  end
end
