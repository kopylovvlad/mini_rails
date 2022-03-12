# frozen_string_literal: true

# Base. Rack layer: START
class MyServer
  # NOTE: Value object
  class ClientRequest
    attr_reader :method_token, :path, :params, :header
    def initialize(method_token, path, params, header)
      @method_token = method_token
      @path = path
      @params = params
      @header = header
    end
  end

  attr_reader :port

  def initialize
    @port = ENV['PORT'] || 9999
    @server = TCPServer.new(@port)
    puts "✅ Вебсервер готов, товарищь. Теперь открой в браузере http://localhost:#{@port}/"
  end

  def fetch_data
    client = @server.accept
    # Accept a HTTP request and parse it
    request_line = client.readline
    method_token, path_with_params, version_number = request_line.split
    # fetch params from a request
    action_params = ::ActionParams.parse(client, path_with_params)
    params = action_params.params
    headers = action_params.headers

    # DELETE, PUT, PATCH support
    if method_token == 'POST' && ['DELETE', 'PUT', 'PATCH'].include?(params[:_method]&.upcase)
      method_token = params[:_method].upcase
    end

    puts "✅ Приняли запрос с методом #{method_token} на ручку #{path_with_params} с версией #{version_number}"
    path, _get_params = path_with_params.split('?')
    request = ClientRequest.new(method_token, path, params, headers)

    # Construct the HTTP request
    http_response = yield request

    # Return the HTTP response to client
    client.puts(http_response)
    client.close
  end
end
# Base. Rack layer: END
