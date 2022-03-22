# frozen_string_literal: true

# TODO: add before_action
class ItemsController < ApplicationController
  def index
    @group = group
    @items = @group.items
    render :index
  end

  def create
    Item.new(permited_params).save
    redirect_to "/groups/#{group.id}/items"
  end

  def destroy
    Item.find_by(group_id: params[:group_id], id: params[:id]).destroy
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
