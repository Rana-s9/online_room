class Spot < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum visit_status: { visited: 0, wanna_visit: 1 }

  validates :name, presence: true
  validates :visit_status, presence: true
  validates :address, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
