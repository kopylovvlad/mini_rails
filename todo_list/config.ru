# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.
require 'bundler/setup'
require '../mini_rails/mini_rails'
require './config/application'

Bundler.require(*MiniRails.groups) if defined?(Bundler)

# Init the applications and load required code
MiniRails::Application.descendants.first.load_code
# Run the application
run ::MiniRails::Application.new
