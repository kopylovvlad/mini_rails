# frozen_string_literal: true

class ItemSerializer < MiniActiveRecord::Serializer
  attributes :id, :title
end
