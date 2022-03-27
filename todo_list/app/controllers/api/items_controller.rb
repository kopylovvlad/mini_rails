# frozen_string_literal: true

module Api
  class ItemsController < ApplicationController
    def index
      group = Group.find(params[:group_id])
      items = group.items
      render_json(items)
    end

    def show
      item = Item.where(show_params).first
      render_json(item)
    end

    private

    def show_params
      params.permit(:group_id, :id).to_h
    end
  end
end
