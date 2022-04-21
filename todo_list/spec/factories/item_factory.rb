# frozen_string_literal: true

MiniFactory.define do
  factory :item, class: 'Item' do
    sequence(:title) { |i| "title_#{i}" }
    done { false }

    trait :done do
      done { true }
    end

    trait :with_group do
      group_id { create(:group).id }
    end
  end
end

