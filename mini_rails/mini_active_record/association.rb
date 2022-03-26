# frozen_string_literal: true

module MiniActiveRecord
  module Association
    # Example of usage: has_many :items
    # It will create method .items
    # The method returns Array
    # @param assosiation_name [String, Symbol]
    # @param class_name [String] Model name
    def has_many(association_name, class_name:)
      instance_eval do
        define_method(association_name) do
          another_model = Object.const_get(class_name)
          attribute = "#{self.class.name.downcase}_id"
          another_model.where(attribute.to_sym => id)
        end
      end
    end

    # Example of usage: has_many :user
    # It will create method .user
    # The method returns Object
    # @param assosiation_name [String, Symbol]
    def belongs_to(association_name)
      instance_eval do
        define_method(association_name) do
          class_name = association_name.to_s.camelize
          another_model = Object.const_get(class_name)
          refer_id = public_send("#{association_name}_id")
          another_model.find(refer_id)
        end
      end
    end
  end
end
