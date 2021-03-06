class Film < ApplicationRecord
  include PgSearch
  pg_search_scope :search, against: [:genre],
                  using: {tsearch: {dictionary: "russian"}}

  has_many :comments, dependent: :destroy

  has_many :film_users, dependent: :destroy
  has_many :users, through: :film_users, source: :user

  validates :title, presence: true
  validates :director, presence: true
  validates :year, presence: true
  validates :kinopoisk_id, presence: true
  validates :kinopoisk_id, uniqueness: true
  validates :genre, presence: true

  mount_uploader :poster, PosterUploader
end
