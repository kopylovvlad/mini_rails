# frozen_string_literal: true

module MiniActionView
  # NOTE: Try not to use instance variables in the class
  # because MiniActionView is separated from MiniActionController
  class Base
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
      current_path = Dir.pwd
      view_path = File.join(current_path, 'app', 'views', entity, view_name.to_s)
      raise "Error: Can't find view #{view_path}" unless File.exist?(view_path)

      ERB.new(File.open(view_path).read).result(binding)
    end
  end
end
