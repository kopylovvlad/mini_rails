# frozen_string_literal: true

 # Note: Here is code reloading logic
 # It works only in development env
 class MiniCodeLoader
  def initialize
    @application = MiniRails::Application.descendants.first
    @typestamps =  {}

    # Get file list and collect file data with updated time
    @application.config.load_paths.each do |path|
      Dir[MiniRails.root.join("#{path}/**/*.rb")].each do |file_path|
        @typestamps[file_path] = File.mtime(file_path)
      end
    end
  end

  # NOTE: Force reload all code with constants
  def self.reload!
    return false unless MiniRails.env.development?

    application = MiniRails::Application.descendants.first
    application.config.load_paths.each do |path|
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
