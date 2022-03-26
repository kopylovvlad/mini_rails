# frozen_string_literal: true

module MiniActionController
  class Base
    include MiniActionController::Render

    def initialize(params, headers)
      @params = Parameters.new(params)
      @headers = headers
    end

    # @param controler_method_name [String, Symbol]
    def build_response(controler_method_name)
      response = public_send(controler_method_name)
      render_layout(response)
    end

    private

    attr_reader :params

    def entity
      self.class.name.gsub('Controller', '').snakecase
    end

    # @param path [String]
    def redirect_to(path, status: SEE_OTHER)
      response_headers = {}
      response_headers['Location'] = path
      Response.new(
        status: status, response_message: no_body,
        content_type: 'html', headers: response_headers
      )
    end

    def no_body
      ''
    end
  end
end

