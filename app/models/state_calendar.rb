class StateCalendar < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :mental_state, presence: true, inclusion: { in: [ "🥳", "☺", "😐", "😭", "😣" ] }
  validates :physical_state, presence: true, inclusion: { in: [ "💃", "🚶‍♀️", "🧍‍♀️", "🛌", "🤒" ] }

  def calendar_date
    date.presence || created_at
  end

  validate :one_state_per_day, on: :create

  def one_state_per_day
    if StateCalendar.exists?(user_id: user_id, date: date)
      errors.add(:base, "この日はすでに記録があります")
    end
  end
end
