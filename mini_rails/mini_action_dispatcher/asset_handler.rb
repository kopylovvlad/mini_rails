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
      return nil unless valid_request?(request)

      path_info = request.path_info
      file_path = find_original_file(path_info)
      if file_path.present?
        puts "✅ Receive request #{request.request_method} to '#{path_info}'"
        puts "Handle is MiniActionDispatch::AssetHandler ..."
        file_context = ::MiniActionView::Asset.new(file_path).render
        # Build rack answer
        return [200, build_headers(path_info), [file_context]]
      end
      # Return nil in order to pass request to another middleware
      nil
    end

    def valid_request?(request)
      (request.get? || request.head?) && request.path_info != '/' && \
        request.path_info =~ /^\/assets\/.*\.(?:css|js)$/
    end

    def find_original_file(path_info)
      file_type = match_file_type(path_info)
      file_name = path_info.gsub(/^\/assets\//, '')
      file_path = ::MiniRails.root.join("app/assets/#{file_type}", file_name)
      # Try to find original file or file with .erb
      if File.exist?(file_path)
        file_path.to_s
      elsif File.exist?("#{file_path}.erb")
        "#{file_path}.erb"
      else
        ''
      end
    end

    def match_file_type(path_info)
      if path_info.end_with?('.css')
        'stylesheets'
      elsif path_info.end_with?('.js')
        'javascript'
      end
    end

    def build_headers(path_info)
      path_info =~ /(\..*)$/
      file_format = Regexp.last_match(1)
      { "Content-Type" => Rack::Mime.mime_type(file_format) }
    end
  end
end
