class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 35 }

  before_validation :set_name, on: :create

  private

  def set_name
    self.name = "Пользователь №#{rand(777)}" if self.name.blank?
  end
end
