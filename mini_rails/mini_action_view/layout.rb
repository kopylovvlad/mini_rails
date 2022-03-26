# frozen_string_literal: true

# TODO: yard
module MiniActionView
  class Layout < ::MiniActionView::Base

    # @param response [MiniActionController::Response]
    def render_response(layout, response)
      status_code = response.status
      response_message = response.response_message
      additional_headers = response.headers.map{ |k,v| "#{k}: #{v}" }.join("\n\r")
      # Construct the HTTP request
      <<~MSG
        HTTP/1.1 #{status_code}
        Content-Type: text/html
        #{additional_headers}

        #{render_layout(layout) { response_message }}
      MSG
    end

    private

    def render_layout(layout_name)
      view_name = "#{layout_name}.html.erb"
      view_path = MiniRails.root.join('app', 'views', self.entity, view_name).to_s
      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
