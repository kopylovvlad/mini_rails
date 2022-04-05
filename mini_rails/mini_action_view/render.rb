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

    private

    def render_view(view_name, item: nil)
      view_path = MiniRails.root.join('app', 'views', entity, view_name.to_s).to_s

      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
