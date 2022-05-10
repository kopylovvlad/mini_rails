# frozen_string_literal: true

module MiniActiveRecord
  # NOTE: Module with data manipulation logic
  module Operate
    def self.included(base)
      base.extend ClassMethods
    end

    def destroy
      self.class.delete_by_id(id)
      true
    end

    # @return [Boolean]
    def save
      @id ||= SecureRandom.uuid
      @created_at ||= DateTime.now
      return false unless valid?

      json = {}
      available_fields.each do |field|
        json[field[:name]] = public_send(field[:name])
      end
      self.class.add_data(json)
      true
    end

    # @return [Boolean]
    # @raise MiniActiveRecord::RecordInvalid
    def save!
      if save
        true
      else
        raise MiniActiveRecord::RecordInvalid
      end
    end

    module ClassMethods
      def table_name
        "#{name.downcase}s"
      end

      def driver
        # DB Driver
        _driver = ::MiniRails::Application.config.driver
        Object.const_get("MiniActiveRecord::#{_driver.to_s.camelize}Driver")
      end

      def delete_by_id(id)
        driver.delete_by_id(id, table_name)
      end

      def add_data(new_item)
        driver.add_data(new_item, table_name)
      end
    end
  end
end
