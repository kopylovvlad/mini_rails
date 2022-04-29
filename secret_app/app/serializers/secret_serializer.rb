# frozen_string_literal: true

class SecretSerializer < ApplicationSerializer
  attributes :message, :password, :view_limit
  attribute :link

  def link
    "/secrets/#{object.id}"
  end
end
