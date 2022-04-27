# frozen_string_literal: true

module MiniActiveRecord
  # NOTE: Driver for YAML-file local data storage
  class YamlDriver < Driver
    class << self
      private

      # NOTE: Delete only test database
      def _destroy_database!
        Dir[MiniRails.root.join("db/*_test.yml")].each do |file_path|
          File.delete(file_path)
        end
      end

      def _delete_by_id(id, table_name)
        store = init_store(table_name)
        store.transaction do
          store[table_name.to_sym].reject! do |i|
            i[:id] == id
          end
        end
      end

      def _add_data(new_item, table_name)
        # Delete existed data
        _delete_by_id(new_item[:id], table_name)
        # Record new data
        store = init_store(table_name)
        store.transaction do
          store[table_name.to_sym] << new_item
        end
      end

      def _all(table_name)
        _where({}, nil, table_name)
      end

      def _where(conditions, table_name, limit = nil)
        store = init_store(table_name)
        store.transaction do
          memo = store[table_name.to_sym]
          memo = conditions.reduce(memo) do |memo, (cond_key, cond_value)|
            if cond_value.is_a?(Array)
              memo.select{ |i| cond_value.include?(i[cond_key])  }
            else
              memo.select{ |i| i[cond_key] == cond_value }
            end
          end

          if limit.nil?
            memo
          elsif limit >= 0
            memo.first(limit)
          elsif limit < 0
            memo.last(-limit)
          end
        end
      end

      def _find(selected_id, table_name)
        _where({id: selected_id}, 1, table_name)
      end

      def _count(conditions, table_name)
        _where(conditions, table_name).size
      end

      def _pluck(conditions, table_name, attribute)
        _where(conditions, table_name).map{ |i| i[attribute] }
      end

      def init_store(table_name)
        file_path = if MiniRails.env.test?
                      "db/db_#{table_name}_test.yml"
                    else
                      "db/db_#{table_name}.yml"
                    end
        store = YAML::Store.new(MiniRails.root.join(file_path).to_s)
        store.transaction do
          store[table_name.to_sym] ||= []
        end
        store
      end
    end
  end
end
