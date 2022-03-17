# frozen_string_literal: true

class ItemsController < MiniActionController::Base
  def index
    @items = Item.all
    render :index
  end

  def create
    i = Item.new(permited_params)
    i.save
    redirect_to '/'
  end

  def destroy
    i = Item.find(params[:id])
    i.destroy
    redirect_to '/'
  end

  private

  def permited_params
    params.permit(*Item.permited_params)
  end
end
