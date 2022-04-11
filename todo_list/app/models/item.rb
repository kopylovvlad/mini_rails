# frozen_string_literal: true

class Item < MiniActiveRecord::Base
  attribute :title, type: String
  attribute :group_id, type: String
  attribute :done, type: [TrueClass, FalseClass], default: false

  validates :title, presence: true, length: { max: 100, min: 3 }

  belongs_to :group

  scope :active, -> { where(done: false) }
  scope :not_active, -> { where(done: true) }

  def active?
    done != true
  end

  class << self
    def permited_params
      [:title, :group_id]
    end
  end
end
