# frozen_string_literal: true

# TODO: divide code by responsibilities
# TODO: create yml-driver object
module MiniActiveRecord
  class Base
    extend ClassMethods
    include InstanceMethods

    def initialize(params = {})
      params.transform_keys(&:to_sym).each do |key, value|
        public_send("#{key}=", value)
      end
    end
  end
end
