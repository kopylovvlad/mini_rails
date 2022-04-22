# frozen_string_literal: true

module MiniRSpec
  module ItLeaf
    class Base
      include Context
      include ::MiniFactory::Shortcuts
      include Matchers
      include RequestHelper

      attr_reader :title
      attr_accessor :proc

      def initialize(title)
        @title = title
        @proc = nil
        @variables = {} # Hash for let! data
      end

      def show_title
        title
      end

      # @param context [String]
      # @param before_callbacks [Array<Proc>]
      # @param variables [Hash<Symbol, Proc>]
      def run_tests(context = nil, before_callbacks = [], variables = {})
        context = [context, title].compact.join(' ')
        return nil if @proc.nil?

        # Clear DB before running the test case
        ::MiniActiveRecord::Base.driver.destroy_database!

        # Run all let blocks
        variables.each do |var_name, proc|
          @variables[var_name] = instance_exec(&proc)
        end

        # Run all before-callbacks
        before_callbacks.each do |callback|
          instance_exec(&callback)
        end
        # Run the test case
        instance_exec(&@proc)
        TestManager.instance.add_success(context)
      rescue ::StandardError => e
        TestManager.instance.add_failure(context, e)
      end

      def describe(described_object)
        raise 'Can not use describe inside "it" block'
      end

      # NOTE: Rewrite aliase
      alias_method :context, :describe

      private

      def method_missing(message, *args, &block)
        if args.present?
          super
        elsif @variables.key?(message)
          @variables[message]
        else
          super
        end
      end
    end
  end
end
