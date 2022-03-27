# frozen_string_literal: true

require_relative 'item_serializer'

class GroupSerializer < MiniActiveRecord::Serializer
  attributes :id, :title, :description, :full_title
  has_many :items, each_serializer: ::ItemSerializer

  def full_title
    [object.title, object.description].join(': ')
  end
end
