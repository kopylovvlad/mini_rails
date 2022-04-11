# frozen_string_literal: true

class GroupsController < ApplicationController
  def create
    @group = Group.new(permited_params)
    if @group.save
      redirect_to '/'
    else
      @alert = @group.errors.full_messages.join(', ')
      render :new, status: "422 Unprocessable Entity"
    end
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
