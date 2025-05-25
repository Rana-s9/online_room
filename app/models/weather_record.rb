class WeatherRecord < ApplicationRecord
  belongs_to :area
  validates :area_id, uniqueness: true
end
