# frozen_string_literal: true

class Secret < ApplicationRecord
  attribute :message, type: String, default: ''
  attribute :password, type: String, default: nil

  attribute :view_limit, type: Integer, default: 0
  attribute :current_views, type: Integer, default: 0

  def password?
    password.present?
  end

  def generate_password!
    self.password = SecureRandom.hex(10)
  end

  def set_limits!
    self.view_limit = 3
  end

  def view_limit?
    view_limit.present? && view_limit > 0
  end

  def out_of_limits?
    view_limit? && current_views >= view_limit
  end

  def increase_views!
    self.current_views += 1
    save!
  end
end
