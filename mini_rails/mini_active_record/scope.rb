# frozen_string_literal: true

module MiniActiveRecord
  module Scope
    def self.included(base)
      base.extend ClassMethods

      base.class_attribute :scopes
      base.scopes = []
    end

    module ClassMethods
      # @param name [String, Symbol]
      # @param procc [Proc]
      def scope(name, procc)
        new_scope_params = { name: name.to_sym, proc: procc }
        self.scopes = scopes | [new_scope_params]

        self.class_eval do
          define_singleton_method(name, &procc)
        end
      end
    end
  end
end
