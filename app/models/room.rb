class Room < ApplicationRecord
  belongs_to :user
  has_many :exchange_diaries, dependent: :destroy
  has_many :whiteboards, dependent: :destroy
  has_many :state_calendars, dependent: :destroy
  has_many :roommate_lists, dependent: :destroy
  has_many :roommates, through: :roommate_lists, source: :user
  has_many :invitation_tokens

  validates :name, presence: true, length: { maximum: 30 }
end
