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
        raise "Undefined command '#{command}'"
      end
    end

    def initialize
      @application = MiniRails::Application.descendants.first
      @application.load_code
    end

    # MiniRails console
    # @param argv [Array<String>]
    def console(argv)
      require "irb"
      IRB.start(__FILE__)
    end

    # MiniRails server
    # @param argv [Array<String>]
    def server(argv)
      ::MiniRails::LocalServer.start
    end

    # Run tests
    # @param argv [Array<String>] List of file pathes
    def test(argv)
      require_relative 'tester'
      require 'rack/test'
      ::MiniRails::Tester.new.call(argv)
    end

    # Runner to run code from one file or a string
    def runner(argv)
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
  end
end
