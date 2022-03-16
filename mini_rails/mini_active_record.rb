# frozen_string_literal: true

require_relative 'mini_active_support'

# TODO: divide code by responsibilities
# TODO: create yml-driver object
class MiniActiveRecord
  module ClassMethods
    def table_name
      "#{name.downcase}s"
    end

    # @param field_name [String, Symbol]
    # @option options [ Class ] :type
    # @option options [ Object ] :default The field's default
    def attribute(field_name, type: String, default: nil)
      new_field_params = {
        name: field_name.to_sym,
        type: type,
        default: default
      }
      self.fields = fields | [new_field_params]

      instance_eval do
        define_method(field_name) do
          field_params = fields.find{ |i| i[:name] == field_name.to_sym }

          instance_variable_get("@#{field_name}") || field_params[:default]
        end

        define_method("#{field_name}=") do |value|
          field_params = fields.find{ |i| i[:name] == field_name.to_sym }
          unless value.is_a?(field_params[:type])
            puts "ERROR: #{value} is not a #{field_params[:type]}"
            return nil
          end

          instance_variable_set("@#{field_name}", value)
        end
      end
    end

    def all
      raw_data = store.transaction do
        store[table_name.to_sym]
      end
      raw_data.map { |data| new(data) }
    end

    def find(selected_id)
      raw_data = store.transaction do
        store[table_name.to_sym].find do |i|
          i[:id] == selected_id
        end
      end
      new(raw_data)
    end

    def delete_by_id(id)
      store.transaction do
        store[table_name.to_sym].reject! do |i|
          i[:id] == id
        end
      end
    end

    def add_data(new_item)
      store.transaction do
        store[table_name.to_sym] << new_item
      end
    end

    private

    def store
      @store ||= begin
        store = YAML::Store.new("db_#{table_name}.yml")
        store.transaction do
          store[table_name.to_sym] ||= []
        end
        store
      end
    end
  end

  module InstanceMethods
    def self.included(base)
      base.class_attribute :fields
      base.fields = []

      base.attribute :id, type: String
    end

    def available_fields
      fields
    end

    def save
      @id ||= SecureRandom.uuid
      json = {}
      available_fields.each do |field|
        json[field[:name]] = public_send(field[:name])
      end
      self.class.add_data(json)
    end

    def destroy
      self.class.delete_by_id(id)
    end
  end

  extend ClassMethods
  include InstanceMethods

  def initialize(params = {})
    params.transform_keys(&:to_sym).each do |key, value|
      public_send("#{key}=", value)
    end
  end
end
