# frozen_string_literal: true

require_relative 'callbacks/callback'

module MiniActionController
  module Callbacks
    def self.included(base)
      base.class_attribute :callbacks
      base.callbacks = []

      base.extend ClassMethods
    end

    module ClassMethods
      # Example of usage:
      # before_action :initial_value, only: [:index, :show], unless: -> { @foo.nil? }
      # before_action :initial_value, only: [:index, :show], if: -> { @foo }
      # @param method [String, Symbol]
      # @param args [Hash]
      # @option args [Array<String, Symbol>] :only
      # @option args [Array<String, Symbol>] :except
      # @option args [Proc, Symbol, String] :if
      # @option args [Proc, Symbol, String] :unless
      def before_action(method, args = {})
        callback = Callback.new(
          method: method.to_sym,
          only: (args[:only] || []).map!(&:to_sym),
          except: (args[:except] || []).map!(&:to_sym),
          if: args[:if],
          unless: args[:unless]
        )
        self.callbacks = callbacks.clone + [callback]
      end
    end

    private

    def run_callbacks_for(action)
      self.class.callbacks.filter do |obj|
        # 1: Check :only and :except conditions
        next unless obj.match_for?(action)

        # 2: Check :if and :unless conditions
        send(obj.method_to_run) if check_conditions(obj)
      end
    end

    def check_conditions(obj)
      return true if obj.without_logic_conditions?

      if obj.has_if_condition?
        exec_callback(obj.if_condition) == true
      elsif obj.has_unless_condition?
        exec_callback(obj.unless_condition) == false
      end
    end

    def exec_callback(callback)
      callback.is_a?(Proc) ? callback.call : send(callback)
    end
  end
end
