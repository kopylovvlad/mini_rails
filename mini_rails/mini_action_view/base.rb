# frozen_string_literal: true

module MiniActionView
  # NOTE: Try not to use instance variables in the class
  # because MiniActionView is separated from MiniActionController
  class Base
    include ::MiniActionView::Reader

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

    # @param view_name [String, Symbol]
    def render_partial(view_name)
      render_view("_#{view_name}.html.erb")
    end

    private

    def render_view(view_name)
      view_path = MiniRails.root.join('app', 'views', entity, view_name.to_s).to_s

      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
