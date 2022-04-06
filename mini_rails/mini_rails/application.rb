# frozen_string_literal: true

module MiniRails
  class Application
    # The main endpoint for config.ru and ruby script to run the application
    # It builds the application with all middlewares
    def self.build_app
      # Base middlewares
      middlewares = []
      middlewares << ::MiniActionDispatch::StaticHandler

      # Middlewares for development end
      middlewares << Rack::Reloader if ::MiniRails.env.development?

      base = ::MiniActionDispatch::RequestHandler.new
      middlewares.reduce(base) do |app, middleware|
        puts "current app: #{middleware.to_s}"
        middleware.new(app)
      end
    end

    def self.config
      Config.instance
    end

    def self.load_code
      config.load_paths.each do |path|
        Dir[MiniRails.root.join("#{path}/**/*.rb")].each { |f| require_relative f }
      end
    end
  end
end
