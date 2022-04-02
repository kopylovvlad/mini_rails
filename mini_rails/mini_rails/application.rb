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

      config.autoload_paths.each do |path|
        Dir[MiniRails.root.join("#{path}/**/*.rb")].each { |f| require_relative f }
      end
    end

    def self.run
      load_code
      ::MiniRails::Server.start
    end
  end
end
