# frozen_string_literal: true

require_relative 'shortcuts'

module MiniFactory
  class Builder
    include Shortcuts
    attr_reader :attributes

    def initialize(klass)
      @klass = klass
      @attributes = {}
      @traits = {}
    end

    # @param number [Integer] Params for sequences
    # @param selected_traits [Array<Symbol>]
    # @param opts [Hash<Symbol, Object>]
    def build_object(number = 1, selected_traits = [], opts = {})
      if @klass.is_a?(String)
        @klass = Object.const_get(@klass)
      end
      unless selected_traits.is_a?(Array)
        selected_traits = [selected_traits]
      end

      # 1: Collect attributes from traits
      trait_attrs = {}
      selected_traits.each do |trait_name|
        if @traits.key?(trait_name)
          @traits[trait_name].each do |k,v|
            trait_attrs[k] = v
          end
        end
      end

      # 2: Collect all attributes
      all_attributes = (opts.keys + trait_attrs.keys + @attributes.keys).uniq

      # 3: Assign data
      attrs = all_attributes.reduce({}) do |memo, key|
        memo[key] = if opts.key?(key)
                      opts[key]
                    elsif trait_attrs.key?(key)
                      fetch_params(trait_attrs[key], number)
                    else
                      fetch_params(@attributes[key], number)
                    end
        memo
      end
      @klass.new(**attrs)
    end

    # @param number [Integer] Params for sequences
    # @param opts [Hash<Symbol, Object>]
    def create_object(number = 1, opts = {})
      build(number, opts).save!
    end

    # Example of usage:
    # senquence(:title) { |i| "My title ##{i}" }
    # @param attr_name [String, Symbol]
    def sequence(attr_name, &block)
      @attributes[attr_name.to_sym] = {
        type: :sequence,
        block: block
      }
    end

    # @param trait_name [String, Symbol]
    def trait(trait_name, &block)
      trait_builder = self.class.new(@klass)
      trait_builder.instance_exec(&block)
      @traits[trait_name.to_sym] = trait_builder.attributes
      nil
    end

    private

    def method_missing(message, *args, &block)
      @attributes[message] = {
        type: :attribute,
        block: block
      }
    end

    def fetch_params(params, number)
      if params[:type] == :attribute
        params[:block].call
      else
        params[:block].call(number)
      end
    end
  end
end
