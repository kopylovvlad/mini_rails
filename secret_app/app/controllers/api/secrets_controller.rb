# frozen_string_literal: true

module Api
  class SecretsController < ::Api::ApplicationController
    def create
      secret = SecretMutator.new.create(create_params)
      render_json(secret, serializer: SecretSerializer, status: '201 Created')
    end

    def show
      secret = Secret.find(params[:id])
      return out_of_limits if secret.out_of_limits?

      if secret.password? && secret.password != params[:password]
        forbidden
      else
        secret.increase_views! if secret.view_limit?
        render_json(secret, serializer: SecretShortSerializer)
      end
    end

    private

    def create_params
      params.permit(:message, :with_password, :with_limit)
    end

    def out_of_limits
      render_json({error: 'out of limits'}, status: '403 Forbidden')
    end

    def forbidden
      render_json({error: 'it requires password'}, status: '403 Forbidden')
    end
  end
end
