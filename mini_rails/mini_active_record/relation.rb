# frozen_string_literal: true

module MiniActiveRecord
  module Relation
    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [MiniActiveRecord::Proxy]
    def where(conditions = {})
      init_proxy.where(conditions)
    end

    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [MiniActiveRecord::Base]
    def find_by(conditions)
      where(conditions).first
    end

    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [Object]
    # @raise [MiniActiveRecord::RecordNotFound]
    # @return [MiniActiveRecord::Base]
    def find_by!(conditions)
      item = where(conditions).first
      raise ::MiniActiveRecord::RecordNotFound if item.nil?
      item
    end

    # @return [MiniActiveRecord::Proxy]
    def all
      where({})
    end

    # @return [MiniActiveRecord::Base]
    def first
      where.first
    end

    # @return [MiniActiveRecord::Base]
    def last
      where.last
    end

    # @return [MiniActiveRecord::Base]
    # @raise [MiniActiveRecord::RecordNotFound]
    def find(selected_id)
      find_by!({id: selected_id})
    end

    private

    def init_proxy
      # proxy_class is a child of MiniActiveRecord::Proxy
      self.proxy_class.new({})
    end
  end
end
