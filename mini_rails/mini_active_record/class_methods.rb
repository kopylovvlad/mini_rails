# frozen_string_literal: true

module MiniActiveRecord
  # TODO: separate methods into different classes
  module ClassMethods
    def table_name
      "#{name.downcase}s"
    end

    # @param field_name [String, Symbol]
    # @option options [Class] :type
    # @option options [Object] :default The field's default
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
          return false if value.nil?

          field_params = fields.find{ |i| i[:name] == field_name.to_sym }
          unless value.is_a?(field_params[:type])
            puts "ERROR: #{field_name} with value #{value} is not a #{field_params[:type]}"
            return nil
          end

          instance_variable_set("@#{field_name}", value)
        end
      end
    end

    # Example of usage: has_many :items
    # It will create method .items
    # The method returns Array
    # @param assosiation_name [String, Symbol]
    # @param class_name [String] Model name
    def has_many(association_name, class_name:)
      instance_eval do
        define_method(association_name) do
          another_model = Object.const_get(class_name)
          attribute = "#{self.class.name.downcase}_id"
          another_model.where(attribute.to_sym => id)
        end
      end
    end

    # Example of usage: has_many :user
    # It will create method .user
    # The method returns Object
    # @param assosiation_name [String, Symbol]
    def belongs_to(association_name)
      instance_eval do
        define_method(association_name) do
          class_name = association_name.to_s.camelize
          another_model = Object.const_get(class_name)
          refer_id = public_send("#{association_name}_id")
          another_model.find(refer_id)
        end
      end
    end

    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [Array<Object>]
    def where(conditions)
      conditions.reduce(all) do |scope, (method_name, value)|
        if value.is_a?(Array)
          scope.select{ |i| value.include?(i.public_send(method_name)) }
        else
          scope.select{ |i| i.public_send(method_name) == value }
        end
      end
    end

    # @param conditions [Hash<Symbol, Object>] Object could be String, Integer, Array
    # @return [Object]
    def find_by(conditions)
      where(conditions).first
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
end
