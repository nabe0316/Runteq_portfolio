class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { minimum: 2 }, if: :name_required?

  has_one :tree
  has_many :messages

  private

  def name_required?
    new_record? || name.present?
  end
end
