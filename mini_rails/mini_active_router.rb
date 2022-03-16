# frozen_string_literal: true

require 'singleton'

class MiniActiveRouter
  include ::Singleton

  def initialize
    @map = {}
    @fallback = nil
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
    @fallback = to
  end

  def find(method, path)
    key = [method, path].join('_')
    location = @map[key] || @fallback
    raise "Can't find route for #{method}##{path}" if location.nil?

    location.split('#')
  end

  private

  def write_to_map(method, path, to:)
    key = [method, path].join('_')
    @map[key] = to
  end
end
