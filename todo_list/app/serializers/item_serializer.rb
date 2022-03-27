# frozen_string_literal: true

class ItemSerializer < MiniActiveRecord::Serializer
  attributes :id, :title, :created_at
end
