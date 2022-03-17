# frozen_string_literal: true

module MiniActionController
  class Response
    attr_reader :status, :response_message, :headers

    def initialize(status: , response_message:, headers: {})
      @status = status
      @response_message = response_message
      @headers = headers
    end
  end
end
