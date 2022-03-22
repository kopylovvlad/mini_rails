# frozen_string_literal: true

class Item < MiniActiveRecord::Base
  attribute :title, type: String
  attribute :group_id, type: String

  belongs_to :group

  class << self
    def permited_params
      [:title, :group_id]
    end
  end
end
