class Like < ApplicationRecord
  belongs_to :user
  belongs_to :message
  validates :user_id, uniqueness: { scope: :message_id }
end
