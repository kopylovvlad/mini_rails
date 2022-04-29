# frozen_string_literal: true

module SecretApp
  # App config is here
  class Application < MiniRails::Application
    # For code reloading
    config.load_paths << MiniRails.root.join('lib')
    config.load_paths << MiniRails.root.join('app/mutators')
    config.load_paths << MiniRails.root.join('app/decorators')

    # In order to change DB-driver
    # config.driver = :yaml
  end
end
