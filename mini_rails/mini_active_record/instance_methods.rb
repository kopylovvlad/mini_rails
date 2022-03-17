# frozen_string_literal: true

module MiniActiveRecord
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
end
