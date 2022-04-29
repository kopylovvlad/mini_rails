# frozen_string_literal: true

class SecretsController < ApplicationController
  def create
    item = SecretMutator.new.create(create_params)
    @secret = SecretDerocator.new(item)
    render :create, status: '201 Created'
  end

  def show
    @secret = Secret.find(params[:id])
    render :show
  end

  private

  def create_params
    params.permit(:message, :with_password, :with_limit)
  end
end
