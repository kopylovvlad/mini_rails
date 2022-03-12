# frozen_string_literal: true

class ActionParams
  class Data
    attr_reader :headers, :params
    def initialize(headers, params)
      @header = headers
      @params = params
    end
  end

  # @param client [TCPSocket]
  # @param path [String] In order to fetch GET-params from path
  def self.parse(client, path)
    if path.include?('?')
      path, get_params_string = path.split('?')
      get_params = get_params_string.split('&').map do |string|
        k,v = string.split('=')
        {k => v}
      end.reduce(:merge).transform_keys(&:to_sym)
    else
      get_params = {}
    end
    # Extract the headers from the request
    headers = {}
    while true
      line = client.readline
      break if line == "\r\n"
      header_name, value = line.split(": ")
      headers[header_name] = value
    end
    # Attain the Content-Length header
    body = client.read(headers['Content-Length'].to_i)
    # Decode it
    # TODO: Add support for params with brackets
    # https://stackoverflow.com/a/7946494
    post_params = URI.decode_www_form(body).to_h.transform_keys(&:to_sym)
    # Merge GET and POST params
    Data.new(headers, get_params.merge(post_params))
  end
end
# Base. Action Params layer: START
