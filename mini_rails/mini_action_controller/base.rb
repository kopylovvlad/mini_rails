# frozen_string_literal: true

module MiniActionController
  class Base
    include MiniActionController::Render

    def initialize(params, headers)
      @params = Parameters.new(params)
      @headers = headers
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
        status: status, response_message: no_body, headers: response_headers
      )
    end

    def no_body
      ''
    end
  end
end

