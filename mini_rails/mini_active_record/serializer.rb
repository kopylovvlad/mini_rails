# frozen_string_literal: true

module MiniActiveRecord
  class Serializer
    attr_reader :object

    class_attribute :fields_to_serialize
    self.fields_to_serialize = []

    # @param object [Object] an object to serialize
    def initialize(object)
      @object = object
    end

    class << self
      # @param attr_name [String, Symbol]
      # @param key [String, Symbol]
      # @param serializer [MiniActiveRecord::Serializer]
      # @param each_serializer [MiniActiveRecord::Serializer]
      def attribute(attr_name, key: nil, serializer: nil, each_serializer: nil)
        meta_data = { attr_name: attr_name.to_s, key: key&.to_sym,
                      serializer: serializer, each_serializer: each_serializer }
        # In order not to pass array by reference
        self.fields_to_serialize = (self.fields_to_serialize.clone + [meta_data])
        nil
      end

      alias_method :has_many, :attribute
      alias_method :belongs_to, :attribute

      # @param attrbts [Array<String, Symbol>]
      def attributes(*attrbts)
        attrbts.each { |i| attribute(i) }
        nil
      end
    end

    # @return [Hash<String, Object>]
    def as_json
      self.fields_to_serialize.reduce({}) do |memo, field_info|
        key = field_info[:key] || field_info[:attr_name]
        value = call_for_value(field_info[:attr_name])
        serialized_value = serialize_value(field_info, value)
        memo[key] = serialized_value.as_json
        memo
      end
    end

    # @return [String]
    def to_json
      JSON.dump(as_json)
    end

    private

    def call_for_value(attr_name)
      if respond_to?(attr_name)
        public_send(attr_name)
      else
        object.public_send(attr_name)
      end
    end

    def serialize_value(field_info, value)
      if !field_info[:each_serializer].nil?
        value.map{ |i| field_info[:each_serializer].new(i) }
      elsif !field_info[:serializer].nil?
        field_info[:serializer].new(value)
      else
        value
      end
    end
  end
end
