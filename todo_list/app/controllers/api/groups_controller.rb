# frozen_string_literal: true

module Api
  class GroupsController < ::Api::ApplicationController
    before_action :groups, only: [:index]
    before_action :group, only: [:show]

    def index
      render_json(@groups, each_serializer: GroupSerializer)
    end

    def show
      render_json(@group, serializer: GroupSerializer)
    end

    private

    def groups
      @groups = Group.all
    end

    def group
      @group = Group.find(params[:id])
    end
  end
end
