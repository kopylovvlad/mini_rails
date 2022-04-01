# frozen_string_literal: true

# TODO: yard
module MiniActionView
  class Layout < ::MiniActionView::Base

    # @param response [MiniActionController::Response]
    def render_response(layout, response)
      status_code, _status_text = response.status.split(' ')
      response_message = response.response_message
      additional_headers = response.headers.map{ |k,v| "#{k}: #{v}" }.join("\n\r")
      headers = {"Content-Type" => "text/html"}.merge(response.headers)
      response_body = render_layout(layout) { response_message }

      # Construct the Rack response
      [status_code, headers, [response_body]]
    end

    private

    def render_layout(layout_name)
      view_name = "#{layout_name}.html.erb"
      view_path = MiniRails.root.join('app', 'views', self.entity, view_name).to_s
      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
