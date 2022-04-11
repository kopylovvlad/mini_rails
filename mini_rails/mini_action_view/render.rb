# frozen_string_literal: true

module MiniActionView
  module Render
    # @param view_name [String, Symbol]
    #   Can be: '_header', :header, 'shared_header'
    #   For symbol it adds _ in the beggining of name.
    # @param collection [Array<Object>] each item will be passed as 'item' variable
    # @param item [Object]
    def render_partial(view_name, collection: [], item: nil)
      if view_name.is_a?(Symbol)
        return render_partial("_#{view_name}", collection: collection, item: item)
      end
      unless view_name.include?('.html.erb')
        return render_partial("#{view_name}.html.erb", collection: collection, item: item)
      end

      if collection.size > 0
        collection.map { |i| render_view(view_name, item: i) }.join('')
      else
        render_view(view_name, item: item)
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

    # Example of usage:
    # javascript_include_tag "application"
    # It generates link
    # <script src="/assets/application.js"></script>
    def javascript_include_tag(file_name)
      <<~STR
        <script src="/assets/#{file_name}.js"></script>
      STR
    end

    private

    # NOTE: If view_name has `/` symbol it searches for a file in app/views folder
    # If view_name hasn't `/` symbol it searches for a file in entity folder
    def render_view(view_name, item: nil)
      root_path = MiniRails.root.join('app', 'views')
      unless view_name.include?('/')
        root_path = root_path.join(entity)
      end

      view_path = root_path.join(view_name).to_s
      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
