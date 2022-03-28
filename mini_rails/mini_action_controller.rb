# frozen_string_literal: true

require_relative 'mini_action_controller/callbacks'
require_relative 'mini_action_controller/parameters'
require_relative 'mini_action_controller/render'
require_relative 'mini_action_controller/response'
require_relative 'mini_action_controller/rescuable'

require_relative 'mini_action_controller/base'

module MiniActionController
  # TODO: Add status matcher ex:
  # status: :ok
  # status: 201
  # status: "200 OK"
  DEFAULT_STATUS = "200 OK"
  SEE_OTHER = "303 See Other"
end
