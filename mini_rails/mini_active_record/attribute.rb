# frozen_string_literal: true

module MiniActiveRecord
  module Attribute
    def self.included(base)
      base.extend ClassMethods

      base.class_attribute :fields
      base.fields = []

      base.attribute :id, type: String
      base.attribute :created_at, type: DateTime

      base.alias_method :available_fields, :fields
    end

    module ClassMethods
      # @param field_name [String, Symbol]
      # @option options [Class, Array<Class>] :type
      # @option options [Object] :default The field's default
      def attribute(field_name, type: String, default: nil)
        new_field_params = {
          name: field_name.to_sym,
          type: type,
          default: default
        }
        self.fields = fields | [new_field_params]

        instance_eval do
          # Define getter
          define_method(field_name) do
            field_params = fields.find{ |i| i[:name] == field_name.to_sym }
            instance_variable_get("@#{field_name}") || field_params[:default]
          end

          # Define setter
          define_method("#{field_name}=") do |value|
            return false if value.nil?

            # Boolean support
            if ['true', 'false'].include?(value)
              value = value.to_bool
            end

            field_params = fields.find{ |i| i[:name] == field_name.to_sym }

            # Check attribute type
            if type.is_a?(Array)
              unless type.include?(value.class)
                puts "ERROR: #{field_name} with value #{value} is not in #{field_params[:type]}"
                return nil
              end
            else
              unless value.is_a?(field_params[:type])
                puts "ERROR: #{field_name} with value #{value} is not a #{field_params[:type]}"
                return nil
              end
            end

            instance_variable_set("@#{field_name}", value)
          end
        end
      end
    end
  end
end
