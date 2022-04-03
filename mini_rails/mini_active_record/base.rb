# frozen_string_literal: true

module MiniActiveRecord
  class Base
    include Attribute
    include Operate
    include Scope

    extend Association
    extend Relation

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
