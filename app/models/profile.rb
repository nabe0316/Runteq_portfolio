class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :username, presence: true, uniqueness: true, allow_blank: true

  before_validation :set_default_username, if: -> { username.blank? }

  def avatar_url
    if avatar.attached?
      if avatar.content_type == "image/svg+xml"
        avatar.url
      else
        begin
          avatar.variant(resize_to_limit: [128, 128]).processed.url
        rescue ActiveStorage::InvariableError
          avatar.url
        end
      end
    else
      ActionController::Base.helpers.asset_path('default_avatar.png')
    end
  end

  private

  def set_default_username
    self.username = "User#{user.id}" if user
  end
end
