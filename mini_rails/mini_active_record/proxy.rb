# frozen_string_literal: true

module MiniActiveRecord
  # TODO: add order, reorder
  class Proxy
    # @param table_name [String]
    # @param model_class [ActiveRecord::Base]
    # @param where_condition [Hash]
    def initialize(table_name, model_class, where_condition = {})
      @table_name = table_name
      @model_class = model_class
      @where_condition = where_condition.transform_keys(&:to_sym)
      @limit = nil
    end

    # @return [MiniActiveRecord::Proxy]
    def all
      where({})
      self
    end

    # @return [MiniActiveRecord::Proxy]
    def where(conditions)
      @where_condition.merge!(conditions.transform_keys(&:to_sym))
      self
    end

    # @return [MiniActiveRecord::Proxy]
    def limit(number)
      @limit = number
      self
    end

    # @return [ActiveRecord::Base]
    def first
      limit(1)[0]
    end

    # @return [ActiveRecord::Base]
    def last
      limit(-1)[0]
    end

    # @return [Integer]
    def count
      driver.count(@where_condition, @table_name)
    end

    # @param attribute [String, Symbol]
    # @return [Array<Object>]
    def pluck(attribute)
      driver.pluck(@where_condition, @table_name, attribute.to_sym)
    end

    # NOTE: In order to see result in console
    def inspect
      execute
    end

    private

    # NOTE: Use it in order to exec driver even before data manitulation
    # It pass methods to Array<ActiveRecord::Base>
    # For example:
    # .where().each {}
    # .where().where().map {}
    def method_missing(message, *args, &block)
      # 1: Try to find scope in model class
      scope_meta = @model_class.scopes.find{ |i| i[:name] == message }
      if !scope_meta.nil?
        instance_exec(&scope_meta[:proc])
      else
        # 2: Execute and find method
        execute.public_send(message, *args, &block)
      end
    end

    # DB Driver
    def driver
      _driver = ::MiniRails::Application.config.driver
      Object.const_get("MiniActiveRecord::#{_driver.to_s.camelize}Driver")
    end

    # Run driver and wrap raw data to model-class
    # @return [Array<ActiveRecord::Base>]
    def execute
      raw_data = driver.where(@where_condition, @table_name, @limit)
      raw_data.map { |data| @model_class.new(data) }
    end
  end
end
