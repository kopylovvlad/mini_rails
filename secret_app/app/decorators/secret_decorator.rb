# frozen_string_literal: true

class SecretDerocator < SimpleDelegator
  def link
    "http://localhost:9292/secrets/#{id}"
  end
end
