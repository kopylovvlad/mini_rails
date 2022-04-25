# frozen_string_literal: true

module MiniRails
  class Env
    include ::Singleton

    def to_s
      env
    end

    alias_method :inspect, :to_s

    def development?
      env == 'development'
    end

    def production?
      env == 'production'
    end

    def test?
      env == 'test'
    end

    private

    def env
      ENV.fetch('MINI_RAILS_ENV', 'development')
    end
  end
end
