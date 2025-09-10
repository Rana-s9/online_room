class ExchangeDiary < ApplicationRecord
  belongs_to :user
  belongs_to :room

  has_many :reads, dependent: :destroy

  validates :body, presence: true, length: { maximum: 65_535 }
end
