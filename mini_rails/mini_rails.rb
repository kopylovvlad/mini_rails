# frozen_string_literal: true

# By ABC
require 'json'
require 'securerandom'
require 'singleton'
require 'socket'
require 'uri'
require 'yaml/store'

require_relative 'mini_active_support'

# By ABC
require_relative 'mini_action_controller'
require_relative 'mini_action_params'
require_relative 'mini_action_view'
require_relative 'mini_active_record'
require_relative 'mini_active_router'
require_relative 'mini_code_loader'
# require_relative 'mini_rails'
require_relative 'mini_server'

# require_relative 'mini_rails'
require_relative 'mini_rails/application'
require_relative 'mini_rails/config'
require_relative 'mini_rails/env'

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

module MiniRails
  # @return [Array<String>]
  def self.groups
    [ENV.fetch('MINI_RAILS_ENV', 'development')] + ['default']
  end

  def self.root
    Pathname.new(Dir.pwd)
  end

  def self.env
    Env.instance
  end
end
