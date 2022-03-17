# frozen_string_literal: true

class Item < MiniActiveRecord::Base
  attribute :title, type: String

  class << self
    def permited_params
      [:title]
    end
  end
end
