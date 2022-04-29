# frozen_string_literal: true

# NOTE: Just a service object
class SecretMutator
  # @param params [Hash]
  # @option params [String] :message
  # @option params [Boolean] :with_password
  # @option params [Boolean] :with_limit
  def create(params)
    secret = Secret.new(message: params[:message])
    secret.generate_password! if params[:with_password].present?
    secret.set_limits! if params[:with_limit].present?
    secret.save!
    secret
  end
end
