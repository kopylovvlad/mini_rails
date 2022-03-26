# frozen_string_literal: true

# TODO: yard
module MiniActionView
  class JsonLayout
    # @param response [MiniActionController::Response]
    def render_response(response)
      status_code = response.status
      response_message = response.response_message
      additional_headers = response.headers.map{ |k,v| "#{k}: #{v}" }.join("\n\r")
      # Construct the HTTP request
      <<~MSG
        HTTP/1.1 #{status_code}
        Content-Type: application/json
        #{additional_headers}

        #{response_message}
      MSG
    end
  end
end
