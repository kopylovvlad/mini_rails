# frozen_string_literal: true

module MiniRails
  class Server
    def self.start
      app = if ::MiniRails.env.development?
              # Application with reloading
              Rack::Reloader.new(::MiniRails::Application.new)
            else
              ::MiniRails::Applications.new
            end

      ::Rack::Server.start(
        :app => app,
        :Port => ENV['PORT'] || 9292,
        :server => 'puma', # cgi/thin/puma/webrick
        :daemon => false,
        :pid => "server.pid",
        :restart => nil,
        :log_to_stdout => true
      )
    end
  end
end
