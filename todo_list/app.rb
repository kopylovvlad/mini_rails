# frozen_string_literal: true

require '../mini_rails/mini_rails'

Bundler.require(*MiniRails.groups) if defined?(Bundler)

module TodoList
  # Config is here
  class Application < MiniRails::Application
    # For code reloading
    config.autoload_paths << MiniRails.root.join('lib')
  end
end
