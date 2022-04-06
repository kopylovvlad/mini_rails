# frozen_string_literal: true

module MiniActionDispatch
  # Rack-middleware to server static files from 'public' folder
  class StaticHandler
    def initialize(app)
      @app = app
    end

    # NOTE: Attempt to find file by path.
    # If doesn't find a file, pass the request to another middleware
    def call(env)
      attempt(env) || @app.call(env)
    end

    private

    def attempt(env)
      request = Rack::Request.new(env)
      if valid_request?(request) && file_exist?(request)
        puts "✅ Приняли запрос с методом #{request.request_method} на ручку #{request.path_info}"
        puts "Его обработает MiniActionDispatch::Static ..."
        return Rack::Files.new('public').call(env)
      end
      nil
    end

    def valid_request?(request)
      (request.get? || request.head?) && request.path_info != '/'
    end

    def file_exist?(request)
      file_path = ::MiniRails.root.join('public', request.path_info.delete_prefix('/'))
      File.exist?(file_path)
    end
  end
end
