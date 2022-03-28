# frozen_string_literal: true

module MiniActionController
  module Callbacks
    def self.included(base)
      base.class_attribute :callback_metas
      base.callback_metas = []

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
        new_meta = {
          method: method.to_sym,
          only: (args[:only] || []).map!(&:to_sym),
          except: (args[:except] || []).map!(&:to_sym),
          if: args[:if],
          unless: args[:unless]
        }
        self.callback_metas = callback_metas.clone + [new_meta]
      end
    end

    private

    def run_callbacks_for(action)
      # 1: Check :only and :except
      cbs_to_run = self.class.callback_metas.filter do |meta|
        match_method_name_for(action, meta)
      end

      cbs_to_run.each do |meta|
        worth_to_run = if meta[:if].nil? && meta[:unless].nil?
                        true
                      elsif !meta[:if].nil?
                        exec_callback(meta[:if]) == true
                      elsif !meta[:unless].nil?
                        exec_callback(meta[:unless]) == false
                      end

        send(meta[:method]) if worth_to_run
      end
    end

    def match_method_name_for(action, meta)
      if meta[:only].empty? && meta[:except].empty?
        true
      elsif meta[:only].present? && meta[:only].include?(action.to_sym)
        true
      elsif meta[:except].present? && meta[:except].exclude?(action.to_sym)
        true
      else
        false
      end
    end

    def exec_callback(callback)
      callback.is_a?(Proc) ? callback.call : send(callback)
    end
  end
end
