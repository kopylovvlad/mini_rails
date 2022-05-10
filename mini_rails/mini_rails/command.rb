# frozen_string_literal: true

module MiniRails
  # TODO: Implement 'new' command
  # TODO: Implement runner
  class Command
    # @param command [String]
    # @param argv [Array<String>]
    def self.invoke(command, argv)
      app = new

      if app.respond_to?(command)
        app.public_send(command, argv)
      else
        raise "ERROR: Undefined command '#{command}'"
      end
    end

    # MiniRails console
    # @param argv [Array<String>]
    def console(argv)
      init_application
      require "irb"
      IRB.start(__FILE__)
    end

    # MiniRails server
    # @param argv [Array<String>]
    def server(argv)
      init_application
      ::MiniRails::LocalServer.start
    end

    # Run tests
    # @param argv [Array<String>] List of file pathes
    def test(argv)
      init_application
      require_relative 'tester'
      require 'rack/test'

      ::MiniRails::Tester.new.call(argv)
    end

    # Runner to run code from one file or a string
    def runner(argv)
      init_application

      string = argv.pop
      if string.end_with?('.rb')
        file_path = MiniRails.root.join(string)
        if File.exist?(file_path)
          require file_path
        else
          raise "ERROR: file '#{string}' does not exist"
        end
      else
        eval(string)
      end
    end

    # Create new mini-rails application
    def new(argv)
      app_name = argv.pop
      if app_name.nil? || app_name.size == 0
        puts 'ERROR: Set application name'
        exit 1
      end

      # Load MiniActiveSupport
      require_relative '../mini_active_support.rb'

      new_app_folder = "#{ENV['PWD']}/#{app_name}"
      # 1: Create application folder
      `mkdir #{new_app_folder}`
      # 2: Copy files
      `cp -r #{__dir__}/../dummy_app/* #{new_app_folder}/`
      # 3: Set application config
      config_path = "#{new_app_folder}/config/application.rb"
      file_content = File.read(config_path)
      File.open(config_path, 'w') do |f|
        f << file_content.gsub('<ApplicationName>', app_name.camelize)
      end
      puts "Done! Your application in '#{new_app_folder}' folder"
    end

    private

    def init_application
      # 1: Load code base and all gems
      require_relative '../mini_rails'
      ::Bundler.require(*MiniRails.groups) if defined?(::Bundler)

      # Load application and config
      require './config/application'
      @application = MiniRails::Application.descendants.first
      @application.load_code
    end
  end
end
