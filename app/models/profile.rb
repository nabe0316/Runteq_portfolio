class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true, allow_blank: true

  before_validation :set_default_username, if: -> { username.blank? }

  def avatar_url
    if avatar.attached?
      Cloudinary::Utils.cloudinary_url(avatar.key, width: 128, height: 128, crop: :fill)
    else
      ActionController::Base.helpers.asset_path('default_avatar.png')
    end
  end

  private

  def set_default_username
    self.username = "User#{user.id}" if user
  end
end
