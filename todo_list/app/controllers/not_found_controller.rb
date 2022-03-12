# frozen_string_literal: true

class NotFoundController < ActionController
  def index
    render :index, status: "404 Not Found"
  end
end
