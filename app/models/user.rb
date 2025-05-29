class User < ApplicationRecord
  validates :name, presence: true

  has_many :owned_rooms, class_name: "Room", foreign_key: "user_id", dependent: :destroy
  has_many :exchange_diaries, dependent: :destroy
  has_many :whiteboards, dependent: :destroy
  has_one :area, dependent: :destroy
  has_many :state_calendars, dependent: :destroy
  has_many :roommate_lists, dependent: :destroy
  has_many :rooms, through: :roommate_lists
  has_many :invitation_tokens, dependent: :destroy
  has_many :greetings, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def own?(object)
    id == object&.user_id
  end
end
