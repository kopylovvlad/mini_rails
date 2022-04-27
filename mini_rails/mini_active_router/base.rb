# frozen_string_literal: true

module MiniActiveRouter
  class Base
    include ::Singleton

    def initialize
      @map = []
      @fallback_route = nil
    end

    # NOTE: Do we have any route in the route map
    def any?
      @map.size > 0
    end

    # NOTE: Method for drawing routes map
    # Use it in config/router.rb file
    def draw(&block)
      instance_eval &block
    end

    # @param path [String, Regexp]
    # @param arg [Hash]
    def get(path, arg)
      write_to_map('GET', path, **arg)
    end

    # @param path [String, Regexp]
    # @param arg [Hash]
    def post(path, arg)
      write_to_map('POST', path, **arg)
    end

    # @param path [String, Regexp]
    # @param arg [Hash]
    def delete(path, arg)
      write_to_map('DELETE', path, **arg)
    end

    # @param path [String, Regexp]
    # @param arg [Hash]
    def put(path, arg)
      write_to_map('PUT', path, **arg)
    end

    # @param path [String, Regexp]
    # @param arg [Hash]
    def patch(path, arg)
      write_to_map('PATCH', path, **arg)
    end

    # NOTE: Method for set a route for 404 page
    def not_found(to: )
      @fallback_route = Route.new(nil, nil, to: to)
    end

    # @param method [String]
    # @param path [String]
    def find(method, path)
      # Delete / in the end of path
      selected_route = @map.find{ |route| route.match?(method, path) }
      if !selected_route.nil?
        selected_route
      elsif !@fallback_route.nil?
        @fallback_route
      else
        raise "Can't find route for #{method}##{path}"
      end
    end

    private

    def write_to_map(method, path, to:)
      transformed_path = transform_path(path)
      @map << Route.new(method, transformed_path, to: to)
    end

    def transform_path(path)
      if path.is_a?(Regexp)
        return path
      elsif path.is_a?(String)
        # 1: Find all placeholders
        placeholders = path.scan(/:[0-9a-zA-Z\-_]*/)
        if placeholders.size == 0
          return path
        else
          # 2: Replace it to (?<placeholder_name>[0-9a-zA-Z]*)
          placeholders.each do |placeholder|
            path = path.gsub(placeholder, "(?<#{placeholder}>[0-9a-zA-Z\\-_]*)")
          end

          # 3: Save the route as an regexp
          return Regexp.new("^#{path}$")
        end
      else
        raise 'ERROR: Route path must be String or Regexp'
      end
    end
  end
end
