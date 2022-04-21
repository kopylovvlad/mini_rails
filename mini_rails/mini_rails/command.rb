# frozen_string_literal: true

module MiniRails
  # TODO: Implement 'new' command
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

    # @param argv [Array<String>]
    def console(argv)
      require "irb"
      IRB.start(__FILE__)
    end

    # @param argv [Array<String>]
    def server(argv)
      ::MiniRails::LocalServer.start
    end

    # @param argv [Array<String>] List of file pathes
    def test(argv)
      require_relative 'tester'
      ::MiniRails::Tester.new.call(argv)
    end
  end
end
