# frozen_string_literal: true

module MiniActiveRecord
  class Driver
    class << self
      def delete_by_id(id, table_name)
        _delete_by_id(id, table_name)
      end

      def add_data(new_item, table_name)
        _add_data(new_item, table_name)
      end

      def all(table_name)
        _all(table_name)
      end

      def find(selected_id, table_name)
        _find(selected_id, table_name)
      end

      private

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
