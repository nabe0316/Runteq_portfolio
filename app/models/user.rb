class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[google_oauth2]

  validates :name, presence: true, length: { minimum: 2 }, if: :name_required?

  has_one :tree, dependent: :destroy
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  has_many :messages, dependent: :destroy
  has_many :likes
  has_many :liked_messages, through: :likes, source: :message
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy

  has_one_attached :avatar

  after_create :create_profile

  def avatar_url
    profile.avatar.attached? ? profile.avatar : 'default_avatar.png'
  end

  private

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.name = auth.info.name
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def name_required?
    new_record? || name.present?
  end

  def create_profile
    build_profile(username: name.presence || "User#{id}").save!
  end
end
