# frozen_string_literal: true

module TodoList
  # App config is here
  class Application < MiniRails::Application
    # For code reloading
    config.load_paths << MiniRails.root.join('lib')
    config.load_paths << MiniRails.root.join('app/decorators')

    # In order to change DB-driver
    # config.driver = :yaml
  end
end
