# frozen_string_literal: true

module MiniActionDispatch
  # Rack-middleware to handler rack-request
  class RequestHandler
    # App is another rack-middleware
    def initialize(app = nil)
      @app = app
    end

    def call(env)
      # If route map is empty - pass request to another middleware
      return @app.call(env) unless MiniActiveRouter::Base.instance.any?

      # Wrap data to convenient interface
      req = Rack::Request.new(env)

      # Fetch params from a request
      method_token = req.request_method
      raw_path = req.path || req.path_info
      # Delete / in the end of path
      path = (raw_path == '/' ? raw_path : raw_path.gsub(/\/+$/,''))
      _p, path_params = req.fullpath.split('?')

      # Wrap params to data-object to handle request params and http-headers
      action_params = ::MiniActionParams.parse(req)
      params = action_params.params
      headers = action_params.headers

      # DELETE, PUT, PATCH support
      if method_token == 'POST' && ['DELETE', 'PUT', 'PATCH'].include?(params[:_method]&.upcase)
        method_token = params[:_method].upcase
      end

      puts "✅ Receive request #{method_token} to #{path} with params '#{path_params}'" unless ::MiniRails.env.test?

      # Match path with route map and find the controller to handle request
      selected_route = MiniActiveRouter::Base.instance.find(method_token, path)
      controller_name, controler_method_name = selected_route.controller_data
      # Route's placeholder support such as :id
      placeholders = selected_route.parse_placeholders(path)
      params = params.merge(placeholders)

      unless ::MiniRails.env.test?
        puts "The handler is #{controller_name.camelize}##{controler_method_name} ..."
      end

      # Find controller
      controller_class_name = "#{controller_name.camelize}Controller"
      begin
        controller_class = Object.const_get controller_class_name
      rescue NameError => e
        puts "ERROR: Can't find class #{controller_class_name}"
        raise e
      end
      controller = controller_class.new(params, headers)

      # Run controller’s action
      # Construct the HTTP response and return it
      controller.build_response(controler_method_name)
    end
  end
end
