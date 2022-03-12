# frozen_string_literal: true

class MiniRails
  def self.run
    code_loader = CodeLoader.new
    server = MyServer.new

    # TODO: multy tread
    loop do
      code_loader.check_updates!

      server.fetch_data do |request|
        # client, method_token, path
        method_token = request.method_token
        path = request.path
        params = request.params
        header = request.header

        # Decide what to respond
        controller_name, method_name = ActiveRouter.instance.find(method_token, path)
        controller_class_name = "#{controller_name.camelize}Controller"
        begin
          controller_class = Object.const_get controller_class_name
        rescue NameError => e
          puts "Error: Can't find class #{controller_class_name}"
          raise e
        end

        controller = controller_class.new(params, header)
        response = controller.public_send(method_name)

        # Construct the HTTP request
        http_response = controller.render_response(response)
        http_response
      end
    end
  end
end
