# frozen_string_literal: true

module MiniActiveRecord
  class Base
    include Attribute
    include Operate
    include Scope
    include Validation

    extend Association
    extend Relation

    def self.inherited(base)
      # Create proxy class for the model
      proxy_class = Class.new(::MiniActiveRecord::Proxy)
      # Inject base class to the method .model_class
      # Can't do in inside Class.new {} because it doesn't get base from global scope
      proxy_class.define_method(:model_class) do
        Object.const_get(base.name)
      end
      # Name the new class as Proxy
      proxy_class_name = "#{base.to_s}Proxy"
      # Destroy if the class exists
      if MiniActiveRecord.const_defined?(proxy_class_name)
        MiniActiveRecord.send(:remove_const, proxy_class_name)
      end
      # Create the class
      ::MiniActiveRecord.const_set(proxy_class_name, proxy_class)

      # Define class method for base class
      base.define_singleton_method(:proxy_class) do
        Object.const_get("MiniActiveRecord::#{proxy_class_name}")
      end
    end

    def initialize(params = {})
      params.transform_keys!(&:to_sym)
      # Fill fields and set default values
      available_fields.each do |field|
        field_name = field[:name]
        if params.key?(field_name) && !params[field_name].nil?
          public_send("#{field_name}=", params[field_name])
        else
          public_send("#{field_name}=", field[:default])
        end
      end
      @errors_object = ::MiniActiveRecord::Validation::Errors.new
    end

    # @return [Hash<String, Object>]
    def as_json
      available_fields.reduce({}) do |memo, field|
        field_name = field[:name]
        memo[field_name.to_s] = (public_send(field_name) || field[:default]).as_json
        memo
      end
    end

    # @return [String]
    def to_json
      JSON.dump(as_json)
    end
  end
end
