# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @groups = Group.all
    render :index
  end
end
