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
  end
end
