class Spot < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :comments, dependent: :destroy

  enum visit_status: { visited: 0, wanna_visit: 1 }

  validates :visit_status, presence: true
  validates :name, presence: true
  validates :address, presence: true
  validate :position_place

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def position_place
    if latitude.blank? || longitude.blank?
      errors.add(:base, I18n.t("activerecord.errors.models.spot.attributes.base.position_blank"))
    end
  end
end
