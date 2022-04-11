# frozen_string_literal: true

require_relative 'validation/errors'
require_relative 'validation/base_validation'
require_relative 'validation/length_of_validation'
require_relative 'validation/presence_of_validation'

module MiniActiveRecord
  module Validation
    def self.included(base)
      base.class_attribute :validations
      base.validations = []

      base.extend ClassMethods
    end

    def valid?
      validate!
      errors.size == 0
    end

    def invalid?
      !valid?
    end

    # Runs all validations
    def validate!
      # 1: Init new error object
      @errors_object = ::MiniActiveRecord::Validation::Errors.new
      validation_namespace = ::MiniActiveRecord::Validation
      # 2: Run each validation
      self.validations.each do |validation|
        class_object = "#{validation[:type].to_s.camelize}Validation"

        if validation_namespace.const_defined?(class_object)
          klass = validation_namespace.const_get(class_object)
          klass.new(validation, self).call
        else
          raise "Can not find class #{validation_namespace}::class_object"
        end
      end
      self
    end

    # @return [MiniActiveRecord::Validation::Errors]
    def errors
      @errors_object
    end

    module ClassMethods
      # Example of usage:
      # validates :title, presence: true
      # validates :title, length: { max: 100, min: 3 }
      # @param field_name [String, Symbol]
      # @param presence [Boolean]
      # @param length [Hash]
      # @option length [Number] :max
      # @option length [Number] :min
      def validates(field_name, presence: nil, length: {})
        if presence.present?
          validates_presence_of(field_name)
        end
        if length.present?
          validates_length_of(field_name, max: length[:max], min: length[:min])
        end
      end

      # @param field_name [String, Symbol]
      def validates_presence_of(field_name)
        new_validation = {
          field_name: field_name.to_sym,
          type: :presence_of
        }
        self.validations = validations | [new_validation]
      end

      def validates_length_of(field_name, max: nil, min: nil)
        new_validation = {
          field_name: field_name.to_sym,
          type: :length_of,
          max: max,
          min: min
        }
        self.validations = validations | [new_validation]
      end
    end
  end
end
