class StateCalendar < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :mental_state, presence: true
  validates :physical_state, presence: true
  validates :date, uniqueness: { scope: [ :user_id, :room_id ] }

  def calendar_date
    date.presence || created_at
  end
end
