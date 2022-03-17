# frozen_string_literal: true

module MiniActiveRouter
  class Base
    include ::Singleton

    def initialize
      @map = []
      @fallback_route = nil
    end

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

    def not_found(to: )
      @fallback_route = Route.new(nil, nil, to: to)
    end

    def find(method, path)
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
        # 'group/:group_id/items/:id/delete'.scan(/\/group\/(?<group_id>[0-9]*)\/items\/(?<id>[0-9]*)\/delete/)
        # 1: Find all placeholders
        placeholders = path.scan(/:[0-9a-zA-Z-]*/)
        if placeholders.size == 0
          return path
        else
          # 'groups/:group_id/items/:id/delete'.scan(/:[0-9a-zA-Z]*/)
          # [":group", ":id"]

          # 2: Replace it to (?<placeholder_name>[0-9a-zA-Z]*)
          placeholders.each do |placeholder|
            path = path.gsub(placeholder, "(?<#{placeholder}>[0-9a-zA-Z-]*)")
          end

          # 3: Save route as an regexp
          return Regexp.new(path)
        end
      else
        raise 'ERROR: Route path must be String or Regexp'
      end
    end
  end
end
