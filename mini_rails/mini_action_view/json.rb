# frozen_string_literal: true

module MiniActionView
  class Json
    # @param object [String, Hash, Object]
    def initialize(object)
      @object = object
    end

    # @param status [String]
    # @param content_type [String] html by default
    # @return [MiniActionController::Response]
    def render(status: MiniActionController::DEFAULT_STATUS, content_type: 'json')
      # TODO: rewrite
      response_message = case @object
                         when Array, Hash
                          JSON.dump(@object)
                         when String
                           @object
                         else
                          JSON.dump(@object.as_json)
                         end
      MiniActionController::Response.new(
        status: status, response_message: response_message, content_type: content_type, headers: {},
      )
    end
  end
end
