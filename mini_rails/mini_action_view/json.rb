# frozen_string_literal: true

module MiniActionView
  class Json
    # @param object [String, Hash, Object]
    def initialize(object)
      @object = object
    end

    # @param opts [Hash]
    # @option opts [String] :status Http status
    # @option opts [Object] :serializer child of MiniActiveRecord::Serializer
    # @option opts [Object] :each_serializer Param object should be Array
    # @option opts [String] :root
    # @return [MiniActionController::Response]
    def render(opts = {})
      response_message = build_response_message(opts)
      MiniActionController::Response.new(
        status: opts[:status], response_message: response_message.to_json,
        content_type: 'json', headers: {},
      )
    end

    private

    def build_response_message(opts)
      serializer = opts[:serializer]
      each_serializer = opts[:each_serializer]
      root = opts[:root]

      response_message = if !opts[:serializer].nil?
                           opts[:serializer].new(@object)
                         elsif !opts[:each_serializer].nil?
                           @object.map { |i| opts[:each_serializer].new(i) }
                         else
                           @object
                         end
      if root.nil?
        response_message
      else
        { root => response_message }
      end
    end
  end
end
