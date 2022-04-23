# frozen_string_literal: true

module Api
  class ItemsController < ApplicationController
    before_action :item, only: [:show, :update, :destroy]

    def index
      group = Group.find(params[:group_id])
      items = group.items.to_a
      render_json(items)
    end

    def show
      render_json(@item)
    end

    def create
      @item = Item.new(permited_params)
      if @item.save
        render_json(@item, status: "201 Created")
      else
        render_json({ errors: @item.errors.full_messages },
                      status: "422 Unprocessable Entity")
      end
    end

    def update
      @item.assign_attributes(permited_params)
      if @item.save
        render_json(@item)
      else
        render_json({ errors: @item.errors.full_messages },
                      status: "422 Unprocessable Entity")
      end
    end

    def destroy
      @item.destroy
      render_json({})
    end

    private

    def item
      @item = Item.find_by!(show_params)
    end

    def show_params
      params.permit(:group_id, :id).to_h
    end

    def permited_params
      params.permit(:group_id, :id, :title, :done)
    end
  end
end
