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
      return false if input_method != @method

      if @path.is_a?(String)
        input_path == @path
      elsif @path.is_a?(Regexp)
        input_path =~ @path
      else
        raise 'ERROR: undefined path'
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

  def get(path, arg)
    write_to_map('GET', path, **arg)
  end

  def post(path, arg)
    write_to_map('POST', path, **arg)
  end

  def delete(path, arg)
    write_to_map('DELETE', path, **arg)
  end

  def put(path, arg)
    write_to_map('PUT', path, **arg)
  end

  def patch(path, arg)
    write_to_map('PATCH', path, **arg)
  end

  def not_found(to: )
    @fallback_route = to
  end

  def find(method, path)
    selected_route = @map.find{ |route| route.match?(method, path) }
    if !selected_route.nil?
      selected_route.location.split('#')
    elsif !@fallback_route.nil?
      @fallback_route.split('#')
    else
      raise "Can't find route for #{method}##{path}"
    end
  end

  private

  def write_to_map(method, path, to:)
    @map << Route.new(method, path, to: to)
  end
end
