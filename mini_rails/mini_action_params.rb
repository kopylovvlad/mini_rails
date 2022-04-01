# frozen_string_literal: true

class MiniActionParams
  class Data
    attr_reader :headers, :params
    def initialize(headers, params)
      @header = headers
      @params = params
    end
  end

  # @param request [Rack::Request]
  def self.parse(request)
    params = request.params.transform_keys(&:to_sym)
    headers = request.env.select {|k,v| k.start_with? 'HTTP_'}.collect {|key, val| [key.sub(/^HTTP_/, ''), val]}.to_h
    # Merge GET and POST params
    Data.new(headers, params)
  end
end
# Base. Action Params layer: START
