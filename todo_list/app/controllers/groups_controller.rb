# frozen_string_literal: true

class GroupsController < ApplicationController
  def create
    Group.new(permited_params).save
    redirect_to '/'
  end

  def destroy
    group = Group.find(params[:id])
    group.items.map(&:destroy)
    group.destroy
    redirect_to '/'
  end

  private

  def permited_params
    params.permit(*Group.permited_params)
  end
end
