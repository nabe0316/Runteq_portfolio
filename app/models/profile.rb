class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true, allow_blank: true

  before_validation :set_default_username, if: -> { username.blank? }

  private

  def set_default_username
    self.username = "User#{user.id}" if user
  end
end
