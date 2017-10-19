class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :name, presence: true, length: { maximum: 35 }

  has_many :comments, dependent: :destroy

  has_many :film_users, dependent: :destroy
  has_many :films, through: :film_users, source: :film

  before_validation :set_name, on: :create

  mount_uploader :avatar, AvatarUploader

  private

  def set_name
    self.name = "Пользователь №#{rand(777)}" if self.name.blank?
  end
end
