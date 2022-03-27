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
      # collect and forward instance variable to MiniActionView::Base
      variables_to_pass = collect_variables
      MiniActionView::Base.new(variables_to_pass, entity).render(view_name, status: status)
    end

    # Examples of usage:
    # String: render_json({a: 123}.to_json)
    # Array: render_json([1,2,3])
    # Array with root: render_json([1,2,3], root: 'data')
    # Object. render_json(Item.all)
    # With serializer: render_json(Item.first, serializer: ItemSerializer)
    # With each_serializer: render_json(Item.all, each_serializer: ItemSerializer)
    #
    # @param object [String, Hash, Object]
    # Object should respond to .as_json and return Hash
    # @param opts [Hash]
    # @option opts [String] :status Http status
    # @option opts [Object] :serializer child of MiniActiveRecord::Serializer
    # @option opts [Object] :each_serializer Param object should be Array
    # @option opts [String] :root
    # @return [MiniActionController::Response]
    def render_json(object, opts = {})
      status = opts[:status] = MiniActionController::DEFAULT_STATUS
      MiniActionView::Json.new(object).render(opts.merge(status: status))
    end

    # @param response [MiniActionController::Response]
    def render_layout(response)
      case response.content_type
      when 'html'
        variables_to_pass = collect_variables
        MiniActionView::Layout.new(variables_to_pass, 'layouts').render_response(self.layout, response)
      when 'json'
        MiniActionView::JsonLayout.new.render_response(response)
      else
        raise "ERROR: Undefined content_type '#{response.content_type}'"
      end
    end

    private

    def collect_variables
      instance_variables.reduce({}) do |memo, var_symbol|
        memo[var_symbol] = instance_variable_get(var_symbol)
        memo
      end
    end
  end
end
