# frozen_string_literal: true

module MiniRails
  class Config
    include ::Singleton

    attr_reader :static_paths, :autoload_paths

    def initialize
      @static_paths = ['config']
      @autoload_paths = ['app/models', 'app/controllers']
    end

    def static_paths=(string)
      @static_paths << string
      @static_paths.uniq!
      @static_paths
    end

    def autoload_paths=(string)
      @autoload_paths << string
      @autoload_paths.uniq!
      @autoload_paths
    end
  end
end
