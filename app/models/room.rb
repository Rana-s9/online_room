class Room < ApplicationRecord
  belongs_to :user
  has_many :exchange_diaries, dependent: :destroy
  has_many :whiteboards, dependent: :destroy
  has_many :state_calendars, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
end
