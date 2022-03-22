# frozen_string_literal: true

module MiniActionView
  # NOTE: Try not to use instance variables in the class
  # because MiniActionView is separated from MiniActionController
  class Base
    include ::MiniActionView::Reader
    include ::MiniActionView::Render

    class_attribute :entity
    entity = nil

    # @params variables [Hash<Symbol, Object>]
    # @params layout [String, Symbol]
    # @params entity [String, Symbol]
    def initialize(variables, entity)
      variables.each do |key, value|
        instance_variable_set(key, value)
      end
      self.entity = entity
    end

    # @param view_name [String, Symbol]
    # @param status [String]
    # @return [MiniActionController::Response]
    def render(view_name, status: MiniActionController::DEFAULT_STATUS)
      response_message = render_view("#{view_name}.html.erb")
      MiniActionController::Response.new(
        status: status, response_message: response_message, headers: {}
      )
    end
  end
end
