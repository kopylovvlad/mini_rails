# frozen_string_literal: true

module MiniActionView
  module Render
    # @param view_name [String, Symbol]
    # @param collection [Array<Object>] each item will be passed as 'item' variable
    def render_partial(view_name, collection: [])
      if collection.size > 0
        collection.map do |item|
          render_view("_#{view_name}.html.erb", item: item)
        end.join('')
      else
        render_view("_#{view_name}.html.erb", item: nil)
      end
    end

    # Example of usage:
    # stylesheet_link_tag "application"
    # It generates link
    # <link href="/assets/application.css" media="screen" rel="stylesheet" />
    def stylesheet_link_tag(file_name, media: 'screen')
      # Check the file exist
      erb_file_path = MiniRails.root.join("app/assets/stylesheets/#{file_name}.css.erb")
      file_path = MiniRails.root.join("app/assets/stylesheets/#{file_name}.css")

      if !File.exist?(file_path) && !File.exist?(erb_file_path)
        raise "Stylesheet file '#{file_path}' does not exist"
      end

      # Render link
      <<~STR
        <link href="/assets/#{file_name}.css" media="#{media}" rel="stylesheet" />
      STR
    end

    private

    def render_view(view_name, item: nil)
      view_path = MiniRails.root.join('app', 'views', entity, view_name.to_s).to_s

      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
