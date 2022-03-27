# frozen_string_literal: true

module MiniActiveRecord
  class Base
    include Attribute
    include Operate

    extend Association
    extend Relation

    def initialize(params = {})
      params.transform_keys(&:to_sym).each do |key, value|
        public_send("#{key}=", value)
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
