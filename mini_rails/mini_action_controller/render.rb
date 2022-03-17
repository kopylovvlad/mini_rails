# frozen_string_literal: true

module MiniActionController
  module Render
    def self.included(base)
      base.class_attribute :layout
      base.layout = :application

      # NOTE: In order to set layout write
      # set_layout :<LayoutName>
      base.define_singleton_method(:set_layout) do |layout_name|
        self.layout = layout_name
      end
    end

    # NOTE: MiniActionView is separated from MiniActionController
    # @param view_name [String, Symbol]
    # @param status [String]
    # @return [MiniActionController::Response]
    def render(view_name, status: MiniActionController::DEFAULT_STATUS)
      variables = instance_variables.reduce({}) do |memo, var_symbol|
        memo[var_symbol] = instance_variable_get(var_symbol)
        memo
      end
      MiniActionView.new(variables, entity).render(view_name, status: status)
    end
  end
end
