class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :spot

  validates :body, presence: true
end
