# frozen_string_literal: true

require '../mini_rails/mini_rails'
require 'pry'

# TODO: to core. Autoload paths
Dir['app/models/*.rb'].each { |f| require_relative f }
Dir['app/controllers/*.rb'].each { |f| require_relative f }
Dir['app/views/*.rb'].each { |f| require_relative f }
Dir['config/*.rb'].each { |f| require_relative f }
