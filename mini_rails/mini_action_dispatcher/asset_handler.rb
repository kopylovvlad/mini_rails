# frozen_string_literal: true

module MiniActionDispatch
  # Rack-middleware to handler request and render assets
  class AssetHandler
    def initialize(app)
      @app = app
    end

    # NOTE: Attempt to find asset by path.
    # If doesn't find a file, pass the request to another middleware
    def call(env)
      attempt(env) || @app.call(env)
    end

    private

    def attempt(env)
      request = Rack::Request.new(env)
      path_info = request.path_info
      if valid_request?(request) && file_exist?(path_info)
        puts "✅ Приняли запрос с методом #{request.request_method} на ручку #{path_info}"
        puts "Его обработает MiniActionDispatch::AssetHandler ..."
        file_context = render_file(path_info)
        return [200, build_headers(path_info), [file_context]]
      end
      nil
    end

    def valid_request?(request)
      (request.get? || request.head?) && request.path_info != '/' && \
        request.path_info =~ /^\/assets\/.*\.css$/
    end

    def file_exist?(path_info)
      !find_file(path_info).nil?
    end

    def find_file(path_info)
      file_name = path_info.gsub(/^\/assets\//, '')
      file_path = ::MiniRails.root.join('app/assets/stylesheets', file_name)
      if File.exist?(file_path)
        file_path
      elsif File.exist?("#{file_path}.erb")
        "#{file_path}.erb"
      else
        nil
      end
    end

    def render_file(path_info)
      file_path = find_file(path_info)
      ::MiniActionView::Asset.new.render(file_path)
    end

    def build_headers(path_info)
      path_info =~ /(\..*)\.erb$/ || path_info =~ /(\..*)$/
      file_format = Regexp.last_match(1)
      { "Content-Type" => Rack::Mime.mime_type(file_format) }
    end
  end
end
