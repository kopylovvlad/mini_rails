# frozen_string_literal: true

class ItemsController < ApplicationController
  def index
    @group = group
    @items = @group.items.sort_by(&:active?).map{ |i| ItemDecorator.new(i) }
    render :index
  end

  def create
    Item.new(permited_params).save
    redirect_to "/groups/#{group.id}/items"
  end

  # TODO: before_action
  def update
    item = Item.find_by(group_id: params[:group_id], id: params[:id])
    item.done = params[:done]
    item.save
    redirect_to "/groups/#{group.id}/items"
  end

  # TODO: before_action
  def destroy
    item = Item.find_by(group_id: params[:group_id], id: params[:id])
    item.destroy
    redirect_to "/groups/#{group.id}/items"
  end

  private

  def permited_params
    params.permit(*Item.permited_params)
  end

  def group
    Group.find(params[:group_id])
  end
end
