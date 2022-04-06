# frozen_string_literal: true

module MiniRails
  # Class to run the application on local machine as a ruby-script
  class LocalServer
    def self.start
      ::Rack::Server.start(
        :app => ::MiniRails::Application.build_app,
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
