# frozen_string_literal: true

require_relative 'item_serializer'

class GroupSerializer < MiniActiveRecord::Serializer
  attributes :id, :title, :description, :full_title, :created_at
  attributes :active_count, :not_active_count
  has_many :items, each_serializer: ::ItemSerializer

  def full_title
    [object.title, object.description].join(': ')
  end

  def active_count
    object.items.active.count
  end

  def not_active_count
    object.items.not_active.count
  end
end
