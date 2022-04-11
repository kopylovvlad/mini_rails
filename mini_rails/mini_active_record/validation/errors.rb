# frozen_string_literal: true

module MiniActiveRecord
  module Validation
    class Errors
      # @!method messages
      #   @return [Hash <Symbol, Array<String>>] {name: ["can't be blank"]}
      attr_reader :messages

      include Enumerable

      def initialize
        @messages = {}
      end

      # @param key [String, Symbol]
      # @param string [String]
      def add(key, string)
        key = key.to_sym
        @messages[key] ||= []
        @messages[key] << string
        nil
      end

      # @param key [String, Symbol]
      def delete(key)
        key = key.to_sym
        @messages.delete(key)
      end

      def present?
        size > 0
      end

      def blank?
        !present?
      end

      # @param key [String,Symbol]
      # @return [Array<String>]
      def [](key)
        key = key.to_sym
        messages[key]
      end

      def each(&block)
        @messages.each(&block)
      end

      # @param key [String,Symbol]
      # @return [String]
      def full_message(key)
        full_messages_for(key).join('. ')
      end

      # @return [Array<String>]
      def full_messages_for(key)
        key = key.to_sym
        if messages[key].present?
          messages[key].map{ |i| "#{key.to_s.camelize} #{i}" }
        else
          []
        end
      end

      # @return [Array<String>]
      def full_messages
        messages.keys.map do |key|
          full_messages_for(key)
        end.reduce(:+)
      end

      # @return [Integer]
      def size
        messages.keys.size
      end
    end
  end
end
