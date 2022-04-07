# frozen_string_literal: true

module MiniActionView
  # TODO: Add cache
  class Asset
    # @param file_path [String]
    def render(file_path)
      if file_path.to_s =~ /\.erb$/
        ERB.new(File.open(file_path.to_s).read).result(binding)
      else
        File.open(file_path.to_s).read
      end
    end

    private

    def import(file_name)
      file_path = ::MiniRails.root.join('app/assets/stylesheets', "#{file_name}.css")
      if File.exist?(file_path)
        render(file_path)
      elsif File.exist?("#{file_path}.erb")
        render("#{file_path}.erb")
      else
        raise "Can not open file '#{file_path}'"
      end
    end
  end
end
