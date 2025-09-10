class Area < ApplicationRecord
  belongs_to :user
  has_one :weather_record, dependent: :destroy

  validates :city, presence: true,
                   format: { with: /\A[a-zA-Z]+\z/, message: "はローマ字（英字）のみで入力してください" }
  validates :user_id, uniqueness: true
end
