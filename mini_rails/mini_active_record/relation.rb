# frozen_string_literal: true

module MiniActiveRecord
  # TODO: add proxy
  module Relation
    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [Array<Object>]
    def where(conditions)
      conditions.reduce(all) do |scope, (method_name, value)|
        if value.is_a?(Array)
          scope.select{ |i| value.include?(i.public_send(method_name)) }
        else
          scope.select{ |i| i.public_send(method_name) == value }
        end
      end
    end

    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [Object]
    def find_by(conditions)
      where(conditions).first
    end

    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [Object]
    # @raise [MiniActiveRecord::RecordNotFound]
    def find_by!(conditions)
      item = where(conditions).first
      raise ::MiniActiveRecord::RecordNotFound if item.nil?
      item
    end

    def all
      raw_data = driver.all(self.table_name)
      raw_data.map { |data| new(data) }
    end

    def first
      raw_data = driver.all(self.table_name)[0]
      new(raw_data)
    end

    def last
      raw_data = driver.all(self.table_name)[-1]
      new(raw_data)
    end

    # @raise [MiniActiveRecord::RecordNotFound]
    def find(selected_id)
      raw_data = driver.find(selected_id, table_name)
      raise ::MiniActiveRecord::RecordNotFound if raw_data.nil?
      new(raw_data)
    end
  end
end
