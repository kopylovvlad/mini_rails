# frozen_string_literal: true

module MiniActiveRecord
  module Validation
    # Note: Abstract class
    class BaseValidation
      # @!method messages
      #   @return [Hash<Symbol, Object>]
      # @!method object
      #   @return [MiniActiveRecord::Base]
      # @!method field_name
      #   @return [Symbol]
      attr_reader :meta_data, :object, :field_name

      # @param meta_data [Hash<Symbol, Object>]
      # @param object [MiniActiveRecord::Base]
      def initialize(meta_data, object)
        @meta_data = meta_data
        @object = object
        @field_name = meta_data[:field_name]
      end

      # Note: Child classes have to implement it
      def call
        raise NoMethodError
      end
    end
  end
end
