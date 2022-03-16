# frozen_string_literal: true

require 'singleton'

class MiniActiveRouter
  class Route
    attr_reader :method, :path

    # @param method [String] GET, POST, PATCH, PUT, DELETE
    # @param path [String, Regexp]
    # @param to [String] Name of controller and method ex: 'items#index'
    def initialize(method, path, to:)
      @method = method
      @path = path
      @to = to
    end

    # @param input_method [String]
    # @param input_path [String]
    def match?(input_method, input_path)
      return false if method.nil? || path.nil?
      return false if input_method != @method

      if @path.is_a?(String)
        input_path == @path
      elsif @path.is_a?(Regexp)
        input_path =~ @path
      else
        {}
      end
    end

    # @return [Array<STRING>] Controller's name and controller's method_name
    def controller_data
      location.split('#')
    end

    # @param input_path [String]
    # @return [Hash<Symbols, String>]
    def parse_placeholders(input_path)
      if @path.is_a?(String)
        {}
      elsif @path.is_a?(Regexp)
        if input_path =~ @path
          match_data = Regexp.last_match
          names = match_data.names
          names.reduce({}) do |memo, name|
            # Delete placeholder's sign and save data
            memo[name.gsub(':', '').to_sym] = match_data[name]
            memo
          end
        else
          {}
        end
      else
        {}
      end
    end

    # @return [String]
    def location
      @to
    end
  end

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
