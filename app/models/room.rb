class Room < ApplicationRecord
  belongs_to :user
  has_many :exchange_diaries, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
end
