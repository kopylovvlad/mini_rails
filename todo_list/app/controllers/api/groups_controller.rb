# frozen_string_literal: true

module Api
  class GroupsController < ::Api::ApplicationController
    before_action :groups, only: [:index]
    before_action :group, only: [:show, :update, :destroy]

    def index
      render_json(@groups, each_serializer: GroupSerializer)
    end

    def show
      render_json(@group, serializer: GroupSerializer)
    end

    def create
      @group = Group.new(permited_params)
      if @group.save
        render_json(@group, serializer: GroupSerializer, status: "201 Created")
      else
        render_json({ errors: @group.errors.full_messages },
                      status: "422 Unprocessable Entity")
      end
    end

    def update
      @group.assign_attributes(permited_params)
      if @group.save
        render_json(@group, serializer: GroupSerializer)
      else
        render_json({ errors: @group.errors.full_messages },
                      status: "422 Unprocessable Entity")
      end
    end

    def destroy
      @group.items.map(&:destroy)
      @group.destroy
      render_json({})
    end

    private

    def groups
      @groups = Group.all
    end

    def group
      @group = Group.find(params[:id])
    end

    def permited_params
      params.permit(*Group.permited_params)
    end
  end
end
