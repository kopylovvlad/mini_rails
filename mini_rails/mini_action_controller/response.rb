# frozen_string_literal: true

module MiniActionController
  # An value object
  class Response
    attr_reader :status, :response_message, :content_type, :headers

    def initialize(status: , response_message:, content_type:, headers: {})
      @status = status
      @response_message = response_message
      @content_type = content_type
      @headers = headers
    end
  end
end
