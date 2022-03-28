# frozen_string_literal: true

module Api
  class ApplicationController < ::MiniActionController::Base
    rescue_from ::MiniActiveRecord::RecordNotFound, with: :not_found

    private

    def not_found
      render_json({data: [], error: 'not_found'}, status: "404 Not Found")
    end
  end
end
