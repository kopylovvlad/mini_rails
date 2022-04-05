# frozen_string_literal: true

class ItemDecorator < BaseDecorator
  def text_css
    if active?
      ''
    else
      'disabled'
    end
  end
end
