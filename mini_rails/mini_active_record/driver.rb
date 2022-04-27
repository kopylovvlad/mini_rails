# frozen_string_literal: true

module MiniActiveRecord
  # NOTE: Abstract class.
  # Inherite from the class in order to implement a driver for different DBs.
  class Driver
    class << self
      def destroy_database!
        _destroy_database!
      end

      # @param id [String, Integer]
      # @param table_name [String]
      def delete_by_id(id, table_name)
        _delete_by_id(id, table_name)
      end

      # @param new_item [MiniActiveRecord::Base]
      # @param table_name [String]
      def add_data(new_item, table_name)
        _add_data(new_item, table_name)
      end

      # @param table_name [String]
      def all(table_name)
        _all(table_name)
      end

      # @param conditions [Hash<Symbol, Object>]
      # @param table_name [String]
      # @param limit [Integer]
      def where(conditions, table_name, limit)
        _where(conditions, table_name, limit)
      end

      # @param selected_id [String, Integer]
      # @param table_name [String]
      def find(selected_id, table_name)
        _find(selected_id, table_name)
      end

      # @param conditions [Hash<Symbol, Object>]
      # @param table_name [String]
      def count(conditions, table_name)
        _count(conditions, table_name)
      end

      # @param conditions [Hash<Symbol, Object>]
      # @param table_name [String]
      # @param attribute [Symbol]
      def pluck(conditions, table_name, attribute)
        _pluck(conditions, table_name, attribute)
      end

      private

      def _destroy_database!
        raise NoMethodError
      end

      def _delete_by_id(id, table_name)
        raise NoMethodError
      end

      def _add_data(new_item, table_name)
        raise NoMethodError
      end

      def _all(table_name)
        raise NoMethodError
      end

      def _find(selected_id, table_name)
        raise NoMethodError
      end
    end
  end
end
