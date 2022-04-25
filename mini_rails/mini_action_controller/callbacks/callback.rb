# frozen_string_literal: true

module MiniActionController
  module Callbacks
    # NOTE: Object for encapsulation logic to match action name and conditions
    class Callback
      attr_reader :method_to_run, :only, :except

      # @param args [Hash]
      # @option args [Array<String, Symbol>] :only
      # @option args [Array<String, Symbol>] :except
      # @option args [Proc, Symbol, String] :if
      # @option args [Proc, Symbol, String] :unless
      def initialize(args = {})
        @method_to_run = args[:method]
        @only = args[:only]
        @except = args[:except]
        @if = args[:if]
        @unless = args[:unless]
      end

      # @return [Proc, Symbol, String]
      def if_condition
        @if
      end

      # @return [Proc, Symbol, String]
      def unless_condition
        @unless
      end

      def has_if_condition?
        !@if.nil?
      end

      def has_unless_condition?
        !@unless.nil?
      end

      # @param action [String, Symbol] Name of controller's action
      def match_for?(action)
        return true if without_name_conditions?
        return true if @only.present? && @only.include?(action.to_sym)
        return true if @except.present? && @except.exclude?(action.to_sym)

        false
      end

      def without_name_conditions?
        @only.empty? && @except.empty?
      end

      def without_logic_conditions?
        @if.nil? && @unless.nil?
      end
    end
  end
end
