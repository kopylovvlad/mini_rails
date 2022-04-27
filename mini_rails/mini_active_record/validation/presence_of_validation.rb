# frozen_string_literal: true

module MiniActiveRecord
  module Validation
    # NOTE: Validation class that checks existence of a value
    class PresenceOfValidation < BaseValidation
      def call
        value = object.public_send(field_name)
        return true if value.present?

        object.errors.add(field_name, 'must be present')
      end
    end
  end
end
