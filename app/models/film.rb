class Film < ApplicationRecord
  validates :title, presence: true
  validates :director, presence: true
  validates :year, presence: true

  mount_uploader :poster, PosterUploader
end
