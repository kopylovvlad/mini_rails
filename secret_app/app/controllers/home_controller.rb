# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render :index
  end

  def not_found
    render :not_found, status: '404 Not Found'
  end
end
