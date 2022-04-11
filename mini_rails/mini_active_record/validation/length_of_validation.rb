# frozen_string_literal: true

module MiniActiveRecord
  module Validation
    class LengthOfValidation < BaseValidation
      def call
        value = object.public_send(field_name)
        return if value.nil?

        max = meta_data[:max]
        min = meta_data[:min]
        if max.present? && value.size > max
          object.errors.add(field_name, "must be less then #{max}")
        end
        if min.present? && value.size < min
          object.errors.add(field_name, "must be greater then #{min}")
        end
      end
    end
  end
end
