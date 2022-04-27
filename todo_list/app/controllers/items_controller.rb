# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :find_group
  before_action :find_item, only: [:update, :destroy]

  def index
    @items = @group.items.sort_by(&:active?).map{ |i| ItemDecorator.new(i) }
    render :index
  end

  def create
    @item = Item.new(permited_params)
    if @item.save
      redirect_to "/groups/#{@group.id}/items"
    else
      @alert = @item.errors.full_messages.join(', ')
      render :new, status: '422 Unprocessable Entity'
    end
  end

  def update
    @item.done = params[:done]
    @item.save
    redirect_to "/groups/#{@group.id}/items"
  end

  def destroy
    @item = Item.find_by(group_id: params[:group_id], id: params[:id])
    @item.destroy
    redirect_to "/groups/#{@group.id}/items"
  end

  private

  def find_group
    @group = Group.find(params[:group_id])
  end

  def find_item
    @item = Item.find_by!(group_id: params[:group_id], id: params[:id])
  end

  def permited_params
    params.permit(*Item.permited_params)
  end
end
