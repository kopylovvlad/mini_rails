# frozen_string_literal: true

# Note: Here is code reloading logic
# It works only in development env
class MiniCodeLoader
  def initialize
    @application = MiniRails::Application.descendants.first
    @typestamps =  {}

    # Get file list and collect file data with updated time
    @application.config.autoload_paths.each do |path|
      Dir[MiniRails.root.join("#{path}/**/*.rb")].each do |file_path|
        @typestamps[file_path] = File.mtime(file_path)
      end
    end
  end

  def check_updates!
    return false unless MiniRails.env.development?

    files_to_update = []
    # Collect files with old timestamp
    @typestamps.each do |file_path, timestamp|
      current_timestamp = File.mtime(file_path)
      next if timestamp == current_timestamp

      files_to_update << file_path
      @typestamps[file_path] = current_timestamp
    end
    return false if files_to_update.size == 0

    files_to_update.each do |file_path|
      # Delete full path from file path. Leave only file name
      autoload_paths = @application.config.autoload_paths
      file_name = autoload_paths.reduce(file_path) do |file_path, path|
        file_path.gsub(MiniRails.root.join("#{path}/").to_s, '')
      end
      self.class.delete_const(file_name)
      load(file_path)
    end
    true
  end

  # NOTE: Force reload all code with constants
  def self.reload!
    return false unless MiniRails.env.development?

    application = MiniRails::Application.descendants.first
    application.config.autoload_paths.each do |path|
      Dir[MiniRails.root.join("#{path}/**/*.rb")].each do |file_path|
        # Delete full path from file path. Leave only file name
        file_name = file_path.gsub("#{MiniRails.root.join(path)}/", '')
        delete_const(file_name)
        load(file_path)
      end
    end
    true
  end

  # @param file_name [String] For example 'my_module/my_class.rb'
  def self.delete_const(file_name)
    *module_arr, const_name = file_name.gsub(/\.rb$/, '').camelize.split('::')
    module_arr = ['Object'] if module_arr.size == 0

    current_module = Object.const_get(module_arr.join('::'))
    if current_module.const_defined?(const_name.camelize)
      current_module.send(:remove_const, const_name.camelize)
    end
    nil
  end
end

def reload!
  MiniCodeLoader.reload!
end
