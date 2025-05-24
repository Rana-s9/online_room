class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :rooms
  has_many :exchange_diaries, dependent: :destroy
  has_many :whiteboards, dependent: :destroy
  has_one :area, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def own?(object)
    id == object&.user_id
  end
end
