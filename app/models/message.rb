class Message < ApplicationRecord
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50}
  validates :content, presence: true, length: { maximum: 255}

  def self.ransackable_attributes(auth_object = nil)
    ["title", "content", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
