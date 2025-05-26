class StateCalendar < ApplicationRecord
  belongs_to :user
  belongs_to :room

  validates :mental_state, presence: true, inclusion: { in: [ "🥳", "☺", "😐", "😭", "😣" ] }
  validates :physical_state, presence: true, inclusion: { in: [ "💃", "🚶‍♀️", "🧍‍♀️", "🛌", "🤒" ] }

  def calendar_date
    date.presence || created_at
  end
end
