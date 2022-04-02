# frozen_string_literal: true

# By ABC
require 'date'
require 'json'
require 'puma'
require 'rack'
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

require_relative 'mini_rails/application'
require_relative 'mini_rails/config'
require_relative 'mini_rails/env'
require_relative 'mini_rails/server'

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
