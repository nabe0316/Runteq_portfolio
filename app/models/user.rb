class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { minimum: 2 }, if: :name_required?

  has_one :tree
  has_one :profile, dependent: :destroy
  has_many :messages

  after_create :create_profile

  private

  def name_required?
    new_record? || name.present?
  end

  def create_profile
    build_profile(username: name.presence || "User#{id}").save!
  end
end
