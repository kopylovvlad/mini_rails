# frozen_string_literal: true

module MiniActionView
  # NOTE: Module with logic how to read file and store data into cache
  module Reader
    private

    def cache
      Cache.instance
    end

    # Read the file from cache or open in file system
    # Cache works only in production env
    # @param view_path [String]
    # @return [String]
    def read_or_open(view_path)
      # Check env
      return open_view(view_path) if MiniRails.env.development?
      # Check cache
      return cache[view_path] if cache.key?(view_path)

      # Otherwise read from file
      file_content = open_view(view_path)
      cache[view_path] = file_content
      file_content
    end

    # @param view_path [String]
    # @return [String]
    # @raise [StandardError]
    def open_view(view_path)
      raise "ERROR: Can't find view #{view_path}" unless File.exist?(view_path)
      File.open(view_path).read
    end
  end
end
