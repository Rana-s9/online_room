class InvitationToken < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :token, presence: true, uniqueness: true
  validates :room_id, presence: true
  validates :user_id, presence: true
end
