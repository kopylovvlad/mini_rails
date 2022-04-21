# frozen_string_literal: true

MiniFactory.define do
  factory :group, class: 'Group' do
    sequence(:title) { |i| "title_#{i}" }
    sequence(:description) { |i| "description_#{i}" }

    trait :with_item do
      items { [build(:item)] }
    end
  end
end
