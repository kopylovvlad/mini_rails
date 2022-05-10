# frozen_string_literal: true

module MiniActiveRouter
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

    def present?
      true
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
end
