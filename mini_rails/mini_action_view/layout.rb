# frozen_string_literal: true

module MiniActionView
  class Layout
    include ::MiniActionView::Reader

    # TODO: yard
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

    def render_layout(layout)
      entity = 'layouts'
      # layout_name = 'application' # we can set it in class
      layout_name = layout
      view_name = "#{layout_name}.html.erb"

      view_path = MiniRails.root.join('app', 'views', entity, view_name).to_s
      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
