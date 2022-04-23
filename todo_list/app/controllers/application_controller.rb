# frozen_string_literal: true

class ApplicationController < MiniActionController::Base
  rescue_from ::MiniActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render('not_found/index', status: '404 Not Found')
  end
end
