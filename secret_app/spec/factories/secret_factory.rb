# frozen_string_literal: true

require 'securerandom'

MiniFactory.define do
  factory :secret, class: 'Secret' do
    sequence(:message) { |i| "Hello world ##{i}" }
    password { nil }
    view_limit { 0 }
    current_views { 0 }

    trait :with_password do
      password { SecureRandom.hex(10) }
    end

    trait :with_limits do
      view_limit { 3 }
      current_views { 0 }
    end

    trait :full_limits do
      view_limit { 3 }
      current_views { 3 }
    end
  end
end

