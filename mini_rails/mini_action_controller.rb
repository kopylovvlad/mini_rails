# frozen_string_literal: true

require 'erb'

# TODO: Base class

class MiniActionController
  module Layout
    def self.included(base)
      base.class_attribute :layout
      base.layout = :application
      base.define_singleton_method(:set_layout) do |layout_name|
        self.layout = layout_name
      end
    end
  end

  include Layout
  include MiniActionView

  class Response
    attr_reader :status, :response_message, :headers
    def initialize(status: , response_message:, headers: {})
      @status = status
      @response_message = response_message
      @headers = headers
    end
  end

  class Parameters
    def initialize(raw_params = {})
      @hash = ::MiniActiveSupport::HashWithIndifferentAccess.new(raw_params)
    end

    # @param key [String, Symbol]
    def require(key)
      if @hash.key?(key)
        @hash[key]
      else
        raise "param is missing or the value is empty: #{key}"
      end
    end

    # @param args [Array<Object>]
    def permit(*args)
      @hash.slice(*args)
    end

    private

    def method_missing(message, *args, &block)
      if @hash.respond_to?(message)
        @hash.send(message, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      @hash.respond_to?(method_name, include_private) || super
    end
  end

  DEFAULT_STATUS = "200 OK"
  SEE_OTHER = "303 See Other"

  def initialize(params, headers)
    @params = Parameters.new(params)
    @headers = headers
  end

  private

  attr_reader :params

  def entity
    self.class.name.gsub('Controller', '').snakecase
  end

  # @param path [String]
  def redirect_to(path, status: SEE_OTHER)
    response_headers = {}
    response_headers['Location'] = path
    Response.new(
      status: status, response_message: no_body, headers: response_headers
    )
  end

  def no_body
    ''
  end
end
