# frozen_string_literal: true

require 'socket'
require 'uri'
require 'yaml/store'
require 'securerandom'

require_relative 'mini_code_loader'
require_relative 'mini_server'
require_relative 'mini_active_record'
require_relative 'mini_active_support'
require_relative 'mini_action_view'
require_relative 'mini_action_controller'
require_relative 'mini_action_params'
require_relative 'mini_active_router'
require_relative 'mini_rails'

# TODO: find all rails parts
# rails
# zeitwerk - code loader ✅
# activesupport
# actionview - in progress
# actionpack - responding to web requests
# railties
# activemodel
# activerecord
# globalid

class MiniRails
  def self.run
    code_loader = MiniCodeLoader.new
    server = MiniServer.new

    # TODO: multy tread
    loop do
      code_loader.check_updates!

      server.fetch_data do |request|
        # client, method_token, path
        method_token = request.method_token
        path = request.path
        params = request.params
        header = request.header
        controller_name = request.controller_name
        controler_method_name = request.controler_method_name

        # Decide what to respond
        # controller_name, controler_method_name = MiniActiveRouter.instance.find(method_token, path)
        controller_class_name = "#{controller_name.camelize}Controller"
        begin
          controller_class = Object.const_get controller_class_name
        rescue NameError => e
          puts "Error: Can't find class #{controller_class_name}"
          raise e
        end

        controller = controller_class.new(params, header)
        response = controller.public_send(controler_method_name)

        # Construct the HTTP request
        http_response = controller.render_response(response)
        http_response
      end
    end
  end
end
