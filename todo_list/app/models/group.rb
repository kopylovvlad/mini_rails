# frozen_string_literal: true

class Group < MiniActiveRecord::Base
  attribute :title, type: String
  attribute :description, type: String

  has_many :items, class_name: 'Item'

  validates :title, presence: true, length: { max: 100, min: 3 }
  validates :description, length: { max: 100, min: 3 }

  class << self
    def permited_params
      [:title, :description]
    end
  end
end
