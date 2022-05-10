# frozen_string_literal: true

module MiniActionView
  # TODO: Add cache
  class Asset
    # It renders text file and ERB files
    # @param original_file_path [String]
    # @return [String]
    def initialize(original_file_path)
      @original_file_path = original_file_path
      @file_extention = nil
      @current_folder = set_current_folder
    end

    # @param file_path [String]
    def render(file_path = nil)
      file_path ||= @original_file_path
      file_context = File.open(file_path).read
      if file_path.to_s =~ /\.erb$/
        ERB.new(file_context).result(binding)
      else
        file_context
      end
    end

    private

    def set_current_folder
      @original_file_path =~ /(\..*)\.erb$/ || @original_file_path =~ /(\..*)$/
      @file_extention = Regexp.last_match(1)
      if @file_extention.end_with?('.css')
        ::MiniRails.root.join('app/assets/stylesheets')
      elsif @file_extention.end_with?('.js')
        ::MiniRails.root.join('app/assets/javascript')
      else
        raise "ERROR: Undefined format for file '#{@original_file_path}'"
      end
    end

    def import(file_name)
      @original_file_path = @current_folder.join("#{file_name}#{@file_extention}")
      # Try to find original file or file with .erb
      if File.exist?(@original_file_path)
        render(@original_file_path)
      elsif File.exist?("#{@original_file_path}.erb")
        render("#{@original_file_path}.erb")
      else
        raise "ERROR: Can not open file '#{@original_file_path}'"
      end
    end
  end
end
