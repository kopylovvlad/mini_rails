# frozen_string_literal: true

module MiniActionView
  class JsonLayout
    # @param response [MiniActionController::Response]
    def render_response(response)
      status_code, _status_text = response.status.split(' ')
      response_message = response.response_message
      additional_headers = response.headers.map{ |k,v| "#{k}: #{v}" }.join("\n\r")
      headers = {"Content-Type" => "application/json"}.merge(response.headers)

      # Construct the Rack response
      [status_code, headers, [response_message]]
    end
  end
end
