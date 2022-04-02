# frozen_string_literal: true

module MiniRails
  class Config
    include ::Singleton

    attr_reader :load_paths

    def initialize
      @load_paths = ['config', 'app/controllers', 'app/models', 'app/serializers']
      @@driver = :yaml
    end

    def driver
      @@driver
    end

    def driver=(value)
      @@driver = value
    end

    def load_paths=(string)
      @load_paths << string
      @load_paths.uniq!
      @load_paths
    end
  end
end
