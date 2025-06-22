class Greeting < ApplicationRecord
  belongs_to :user
  belongs_to :room

  enum greeting_type: { welcome: 0, return: 1 }

  validates :greeting_type, presence: true
  validates :message, presence: true
end
