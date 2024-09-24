class Message < ApplicationRecord
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :liking_users, through: :likes, source: :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 255 }

  scope :recent, -> { order(created_at: :desc) }

  after_create :grow_tree
  after_destroy :shrink_tree

  def self.ransackable_attributes(auth_object = nil)
    ["title", "content", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

  private

  def grow_tree
    user.tree.grow
  end

  def shrink_tree
    user.tree.shrink
  end
end
