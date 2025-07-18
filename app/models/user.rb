class User < ApplicationRecord
  validates :name, presence: true
  validates :uid, presence: true, uniqueness: { scope: :provider }, if: -> { uid.present? }

  has_many :owned_rooms, class_name: "Room", foreign_key: "user_id", dependent: :destroy
  has_many :exchange_diaries, dependent: :destroy
  has_many :whiteboards, dependent: :destroy
  has_one :area, dependent: :destroy
  has_many :state_calendars, dependent: :destroy
  has_many :roommate_lists, dependent: :destroy
  has_many :rooms, through: :roommate_lists
  has_many :invitation_tokens, dependent: :destroy
  has_many :greetings, dependent: :destroy
  has_many :spots, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :reads, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :google_oauth2 ]

  def own?(object)
    id == object&.user_id
  end

  def online?
    return false unless last_seen_at
    last_seen_at > 5.minutes.ago
  end

  def offline?
    !online?
  end

  def read(exchange_diary)
    read_exchange_diaries << exchange_diary
  end

  def unread(exchange_diary)
    read_exchange_diaries.destroy(exchange_diary)
  end

  # 同じ部屋に所属するユーザー全員
  def grouped_shared_users
    Room.where(id: owned_rooms.pluck(:id) + rooms.pluck(:id))
      .includes(:users)
      .each_with_object({}) do |room, hash|
        all_users = (room.users + [ room.user ]).uniq
        hash[room.id] = all_users
      end
  end
  # 自分を除く、同じ部屋に属するユーザー全員
  def roommates_except_self(room)
    (room.users + [ room.user ]).uniq.reject { |user| user == self }
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.name = auth.info.name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.create_unique_string
    SecureRandom.uuid
  end
end
