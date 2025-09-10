class Post < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy

  enum relationship: { partner: 0, friend: 1, family: 2, other_relationship: 99 }
  enum post_type: { tips: 0, question: 1 }
  enum situation: { long_distance: 0, sometimes_meet: 1, living_together: 2, other_situation: 99 }
  enum display_name: { username: 0, anonymous: 1, nickname: 2 }

  validates :relationship, presence: true
  validates :post_type, presence: true
  validates :situation, presence: true
  validates :content, presence: true
  validates :custom_relationship, presence: true, if: -> { relationship == "other_relationship" }
  validates :custom_situation, presence: true, if: -> { situation == "other_situation" }
  validates :custom_name, presence: true, if: -> { display_name == "nickname" }

  def display_user
    case display_name
    when "username"
      user.name
    when "anonymous"
      "匿名"
    when "nickname"
      custom_name.presence || "ニックネーム未設定"
    end
  end
end
