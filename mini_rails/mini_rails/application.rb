# frozen_string_literal: true

module MiniRails
  class Application
    def self.config
      Config.instance
    end

    def self.load_code
      config.static_paths.each do |path|
        Dir[MiniRails.root.join("#{path}/**/*.rb")].each { |f| require_relative f }
      end

      # TODO: delete
      config.autoload_paths.each do |path|
        Dir[MiniRails.root.join("#{path}/**/*.rb")].each { |f| require_relative f }
      end
    end

    def self.run
      load_code
      ::MiniRails::Server.start
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

      # Decide what to respond
      controller_class_name = "#{controller_name.camelize}Controller"
      begin
        controller_class = Object.const_get controller_class_name
      rescue NameError => e
        puts "Error: Can't find class #{controller_class_name}"
        raise e
      end

      controller = controller_class.new(params, headers)
      # Construct the HTTP response and return it
      http_response = controller.build_response(controler_method_name)
      http_response
    end
  end
end
