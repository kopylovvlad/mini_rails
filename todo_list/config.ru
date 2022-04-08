# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.
require 'bundler/setup'
Bundler.require(:default) if defined?(Bundler)

require './config/application'

# Init the applications and load required code
MiniRails::Application.descendants.first.load_code

# Run the application
run ::MiniRails::Application.build_app
