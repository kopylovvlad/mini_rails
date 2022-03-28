# frozen_string_literal: true

module MiniActionController
  module Rescuable
    def self.included(base)
      base.class_attribute :rescue_attempts
      base.rescue_attempts = []

      base.extend ClassMethods
    end

    private

    # NOTE: Find first handle for the exception and run
    # @param exception [StandardError]
    def try_to_rescue(exception)
      rescue_attempt = self.class.rescue_attempts.find do |meta|
        exception.is_a?(meta[:exception])
      end
      raise exception if rescue_attempt.nil?

      send(rescue_attempt[:with])
    end

    module ClassMethods
      # Example of usage:
      # rescue_from User::NotAuthorized, with: :deny_access
      # rescue_from ActiveRecord::RecordInvalid, with: :show_errors
      # @param exception [StandardError]
      # @param with [String, Symbol]
      # @raise [StandardError]
      def rescue_from(exception, with: nil)
        if with.nil?
          raise ArgumentError, 'No :with argument'
        end

        rescue_attempt = {
          exception: exception,
          with: with
        }
        self.rescue_attempts = self.rescue_attempts + [rescue_attempt]
      end
    end
  end
end
