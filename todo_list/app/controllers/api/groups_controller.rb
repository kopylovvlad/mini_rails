# frozen_string_literal: true

module Api
  # TODO: Add 404 handler
  class GroupsController < ApplicationController
    def index
      groups = Group.all
      render_json(groups, each_serializer: GroupSerializer)
    end

    def show
      group = Group.find(params[:id])
      render_json group
    end
  end
end
