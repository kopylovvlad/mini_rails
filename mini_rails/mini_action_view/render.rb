# frozen_string_literal: true

module MiniActionView
  module Render
    # @param view_name [String, Symbol]
    def render_partial(view_name)
      render_view("_#{view_name}.html.erb")
    end

    private

    def render_view(view_name)
      view_path = MiniRails.root.join('app', 'views', entity, view_name.to_s).to_s

      ERB.new(read_or_open(view_path)).result(binding)
    end
  end
end
