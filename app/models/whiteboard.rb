class Whiteboard < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :body, length: { maximum: 300 }
end
