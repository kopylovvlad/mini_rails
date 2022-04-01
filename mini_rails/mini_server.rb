# frozen_string_literal: true

# TODO: replace to MiniRails namespace
class MiniServer
  # NOTE: Value object
  class ClientRequest
    attr_reader :method_token, :path, :params, :header, :controller_name, :controler_method_name

    def initialize(method_token, path, params, header, controller_name, controler_method_name)
      @method_token = method_token
      @path = path
      @params = params
      @header = header
      @controller_name = controller_name
      @controler_method_name = controler_method_name
    end
  end

  # attr_reader :port

  # def initialize
  #   @port = ENV['PORT'] || 9999
  #   @server = TCPServer.new(@port)
  #   puts "✅ Вебсервер готов работать в #{MiniRails.env} окружении, товарищь."
  #   puts "Теперь открой в браузере http://localhost:#{@port}/"
  # end

  def self.start
    ::Rack::Server.start(
      :app => ::MiniServer.new,
      :Port => ENV['PORT'] || 9999,
      :server => 'puma', # cgi/thin/puma/webrick
      :daemon => false,
      :pid => "server.pid",
      :restart => nil,
      :log_to_stdout => true
    )
  end

  def call(env)
    req = Rack::Request.new(env)

    # Fetch params from a request
    method_token = req.request_method
    path = req.path || req.path_info
    path_with_params = req.fullpath

    action_params = ::MiniActionParams.parse(req)
    params = action_params.params
    headers = action_params.headers

    # DELETE, PUT, PATCH support
    if method_token == 'POST' && ['DELETE', 'PUT', 'PATCH'].include?(params[:_method]&.upcase)
      method_token = params[:_method].upcase
    end
    puts "✅ Приняли запрос с методом #{method_token} на ручку #{path_with_params}"

    # Route's placeholder support
    selected_route = MiniActiveRouter::Base.instance.find(method_token, path)
    controller_name, controler_method_name = selected_route.controller_data
    placeholders = selected_route.parse_placeholders(path)
    params = params.merge(placeholders)

    puts "Его обработает #{controller_name.camelize}##{controler_method_name} ..."
    request = ClientRequest.new(method_token, path, params, headers, controller_name, controler_method_name)

    # Return the HTTP response to client

    # client, method_token, path
    method_token = request.method_token
    path = request.path
    params = request.params
    header = request.header
    controller_name = request.controller_name
    controler_method_name = request.controler_method_name

    # Decide what to respond
    controller_class_name = "#{controller_name.camelize}Controller"
    begin
      controller_class = Object.const_get controller_class_name
    rescue NameError => e
      puts "Error: Can't find class #{controller_class_name}"
      raise e
    end

    controller = controller_class.new(params, header)
    # Construct the HTTP response
    http_response = controller.build_response(controler_method_name)
    http_response
  end
end
# Base. Rack layer: END
