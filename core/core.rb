# frozen_string_literal: true

require 'socket'
require 'uri'
require 'yaml/store'
require 'securerandom'

require_relative 'code_loader'
require_relative 'my_server'
require_relative 'active_record'
require_relative 'active_support'
require_relative 'action_view'
require_relative 'action_controller'
require_relative 'action_params'
require_relative 'active_router'
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
