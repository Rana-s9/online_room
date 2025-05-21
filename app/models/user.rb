class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :exchange_diaries
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
