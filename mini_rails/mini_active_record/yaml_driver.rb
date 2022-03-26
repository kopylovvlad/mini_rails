# frozen_string_literal: true

module MiniActiveRecord
  class YamlDriver < Driver
    class << self
      private

      def _delete_by_id(id, table_name)
        store = init_store(table_name)
        store.transaction do
          store[table_name.to_sym].reject! do |i|
            i[:id] == id
          end
        end
      end

      def _add_data(new_item, table_name)
        store = init_store(table_name)
        store.transaction do
          store[table_name.to_sym] << new_item
        end
      end

      def _all(table_name)
        store = init_store(table_name)
        store.transaction do
          store[table_name.to_sym]
        end
      end

      def _find(selected_id, table_name)
        store = init_store(table_name)
        store.transaction do
          store[table_name.to_sym].find do |i|
            i[:id] == selected_id
          end
        end
      end

      def init_store(table_name)
        store = YAML::Store.new("db_#{table_name}.yml")
        store.transaction do
          store[table_name.to_sym] ||= []
        end
        store
      end
    end
  end
end
