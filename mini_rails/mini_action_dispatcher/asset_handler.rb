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
      if valid_request?(request)
        file_type = match_file_type(path_info)
        if file_exist?(path_info, file_type)
          puts "✅ Приняли запрос с методом #{request.request_method} на ручку #{path_info}"
          puts "Его обработает MiniActionDispatch::AssetHandler ..."
          file_context = render_file(path_info, file_type)
          return [200, build_headers(path_info), [file_context]]
        end
      end
      nil
    end

    def valid_request?(request)
      (request.get? || request.head?) && request.path_info != '/' && \
        ( request.path_info =~ /^\/assets\/.*\.css$/ || request.path_info =~ /^\/assets\/.*\.js$/ )
    end

    def match_file_type(path_info)
      if path_info =~ /^\/assets\/.*\.css$/
        'stylesheets'
      elsif path_info =~ /^\/assets\/.*\.js$/
        'javascript'
      end
    end

    def file_exist?(path_info, file_type)
      !find_file(path_info, file_type).nil?
    end

    def find_file(path_info, file_type)
      file_name = path_info.gsub(/^\/assets\//, '')
      file_path = ::MiniRails.root.join("app/assets/#{file_type}", file_name)
      if File.exist?(file_path)
        file_path
      elsif File.exist?("#{file_path}.erb")
        "#{file_path}.erb"
      else
        nil
      end
    end

    def render_file(path_info, file_type)
      file_path = find_file(path_info, file_type)
      ::MiniActionView::Asset.new(file_type).render(file_path)
    end

    def build_headers(path_info)
      path_info =~ /(\..*)\.erb$/ || path_info =~ /(\..*)$/
      file_format = Regexp.last_match(1)
      { "Content-Type" => Rack::Mime.mime_type(file_format) }
    end
  end
end
