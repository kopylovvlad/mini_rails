# frozen_string_literal: true

class Group < MiniActiveRecord::Base
  attribute :title, type: String
  attribute :description, type: String

  has_many :items, class_name: 'Item'

  class << self
    def permited_params
      [:title, :description]
    end
  end
end
